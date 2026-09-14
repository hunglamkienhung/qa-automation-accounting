"""Read-only access to the mini-books SQLite file. Mirror of node/be/db/store.js.

Both stacks open the same file the service writes. A missing file is DbUnreachable
and grades Blocked. The WAL store must live on a native Linux filesystem for a WSL
reader to memory-map it -- set MINI_BOOKS_DB to a /tmp path when running under WSL.
"""

from __future__ import annotations

import os
import sqlite3
from pathlib import Path

DB_FILE = Path(os.environ.get("MINI_BOOKS_DB") or Path(__file__).resolve().parents[3] / "services" / "mini-books" / "data" / "mini-books.db")
SCHEMA = Path(__file__).resolve().parents[3] / "services" / "mini-books" / "db" / "schema.sql"
DEBIT_NORMAL = {"asset", "expense"}


class DbUnreachable(Exception):
    pass


def _rows(cur):
    cols = [c[0] for c in cur.description] if cur.description else []
    return [dict(zip(cols, r)) for r in cur.fetchall()]


class Store:
    def __init__(self, file: Path = DB_FILE) -> None:
        self.file = Path(file)
        if not self.file.exists():
            raise DbUnreachable(f"no store at {self.file} -- start mini-books (services/mini-books/serve.sh up)")
        try:
            self.db = sqlite3.connect(f"file:{self.file.as_posix()}?mode=ro", uri=True, timeout=5, isolation_level=None)
            self.db.execute("SELECT 1 FROM accounts").fetchall()
        except sqlite3.Error as err:
            raise DbUnreachable(f"cannot open {self.file}: {err}") from err

    def close(self):
        try:
            self.db.close()
        except sqlite3.Error:
            pass

    def all(self, sql, *p):
        return _rows(self.db.execute(sql, p))

    def get(self, sql, *p):
        r = self.all(sql, *p)
        return r[0] if r else None

    def count(self, table, where="", *p):
        return int(self.get(f"SELECT COUNT(*) AS n FROM {table} {where}", *p)["n"])

    def tables(self):
        return [r["name"] for r in self.all("SELECT name FROM sqlite_master WHERE type='table' ORDER BY name")]

    def lines(self, entry_id):
        """The lines of one entry, oldest first."""
        return self.all("SELECT * FROM lines WHERE entry_id = ? ORDER BY id", entry_id)

    def grand_totals(self):
        """Grand totals of every debit and every credit line -- must be equal."""
        return self.get("SELECT COALESCE(SUM(CASE WHEN side='debit' THEN amount_cents ELSE 0 END),0) AS debit, COALESCE(SUM(CASE WHEN side='credit' THEN amount_cents ELSE 0 END),0) AS credit FROM lines")

    def account_balance(self, account_id):
        """Natural (normal-sign) balance of an account by id."""
        a = self.get("SELECT type FROM accounts WHERE id = ?", account_id)
        t = self.get("SELECT COALESCE(SUM(CASE WHEN side='debit' THEN amount_cents ELSE 0 END),0) AS debit, COALESCE(SUM(CASE WHEN side='credit' THEN amount_cents ELSE 0 END),0) AS credit FROM lines WHERE account_id = ?", account_id)
        return (t["debit"] - t["credit"]) if a["type"] in DEBIT_NORMAL else (t["credit"] - t["debit"])

    def type_total(self, type_):
        """Total natural balance across all accounts of a type."""
        s = 0
        for a in self.all("SELECT id FROM accounts WHERE type = ?", type_):
            s += self.account_balance(a["id"])
        return s


def throwaway():
    """A throwaway in-memory store with the schema applied, for constraint checks."""
    db = sqlite3.connect(":memory:", isolation_level=None)
    db.execute("PRAGMA foreign_keys = ON")
    db.executescript(SCHEMA.read_text(encoding="utf-8").replace("PRAGMA journal_mode = WAL;", ""))
    return db

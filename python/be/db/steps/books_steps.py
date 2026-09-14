"""Steps for be-mini-books-db.feature, plus the shared "drive the service" Givens
the journal, reports, integrity and security features reuse. Mirror of
node/be/db/steps/books.steps.js -- a plugin module.

Seeded accounts accumulate across scenarios, so balance assertions are on deltas
(note, act, check the change); per-entry and grand-total assertions are absolute
because they hold regardless of what else has posted. A source that is not
reachable (no store, service down) sets source_error and grades Blocked.
"""

from __future__ import annotations

import json
import sqlite3
from pathlib import Path

import pytest
from pytest_bdd import given, parsers, then, when

from be.api.venues.books import ACC, ApiUnreachable, MiniBooks
from be.db.store import DbUnreachable, Store, throwaway

books = MiniBooks()
UNREACHABLE = (DbUnreachable, ApiUnreachable)
SEED = Path(__file__).resolve().parents[4] / "services" / "mini-books" / "db" / "seed.sql"


@pytest.fixture(autouse=True)
def books_scenario(request, qa):
    if request.node.get_closest_marker("books") is None:
        yield
        return
    qa.store = None
    qa.books = books
    qa.token = books.seed_book
    qa.user = None
    qa.entry = None
    qa.report = None
    qa.noted = {}
    qa.noted_fig = None
    qa.api = None
    qa.tmp = None
    yield
    if getattr(qa, "tmp", None) is not None:
        try:
            qa.tmp.close()
        except sqlite3.Error:
            pass
    if getattr(qa, "store", None) is not None:
        qa.store.close()


# ---------------------------------------------------------------- helpers


def act(qa, fn):
    if qa.source_error:
        return None
    try:
        return fn()
    except UNREACHABLE as err:
        qa.source_error = str(err)
        return None


def check(qa, description, fn):
    if qa.source_error:
        qa.unobservable(description, "the source could not be reached -- " + qa.source_error)
        return
    try:
        passed, detail = fn()
    except UNREACHABLE as err:
        qa.unobservable(description, str(err))
        return
    qa.check(description, passed, detail)


def _entry_balanced(store, entry_id):
    ls = store.lines(entry_id)
    d = sum(l["amount_cents"] for l in ls if l["side"] == "debit")
    c = sum(l["amount_cents"] for l in ls if l["side"] == "credit")
    return (len(ls) >= 2 and d == c, f"debit {d}, credit {c}")


# ---------------------------------------------------------------- Background


@given("the store is open and the service is reachable")
def store_open(qa):
    if qa.source_error:
        return
    try:
        qa.store = Store()
    except DbUnreachable as err:
        qa.source_error = str(err)
        return
    r = act(qa, lambda: books.get("/health"))
    if qa.source_error:
        return
    if not r or r["status"] != 200:
        qa.source_error = "mini-books did not answer /health: " + (str(r["status"]) if r else "no response")
        return
    qa.evidence("storeFile", str(qa.store.file))


# ---------------------------------------------------------------- drive the service (shared)


@given("an accountant")
def an_accountant(qa):
    qa.token = books.seed_book


def _post_named(qa, fn):
    def go():
        qa.api = fn()
        qa.entry = qa.api["body"] if qa.api["status"] < 300 else None
    act(qa, go)


@given(parsers.parse("a cash sale of {amt:d}"))
@when(parsers.parse("a cash sale of {amt:d}"))
def a_cash_sale(qa, amt):
    _post_named(qa, lambda: books.entry(qa.token, ACC["CASH"], ACC["SALES"], amt))


@given(parsers.parse("rent paid of {amt:d}"))
def rent_paid(qa, amt):
    _post_named(qa, lambda: books.entry(qa.token, ACC["RENT"], ACC["CASH"], amt))


@given(parsers.parse("an owner investment of {amt:d}"))
def owner_investment(qa, amt):
    _post_named(qa, lambda: books.entry(qa.token, ACC["CASH"], ACC["OWNER_CAPITAL"], amt))


@given(parsers.parse("a balanced entry debiting account {dr:d} and crediting account {cr:d} for {amt:d}"))
@when(parsers.parse("a balanced entry debiting account {dr:d} and crediting account {cr:d} for {amt:d}"))
def a_balanced_entry(qa, dr, cr, amt):
    _post_named(qa, lambda: books.entry(qa.token, dr, cr, amt))


@given(parsers.parse('a cash sale of {amt:d} with key "{key}"'))
def a_cash_sale_with_key(qa, amt, key):
    _post_named(qa, lambda: books.entry(qa.token, ACC["CASH"], ACC["SALES"], amt, key=key))
    qa.first_entry = qa.api
    qa.last_amt = amt


@given(parsers.parse('the same cash sale is retried with key "{key}"'))
def same_cash_sale_retried(qa, key):
    def go():
        qa.api = books.entry(qa.token, ACC["CASH"], ACC["SALES"], qa.last_amt, key=key)
        qa.second_entry = qa.api
    act(qa, go)


@given("the entry is reversed by the admin")
@when("the entry is reversed by the admin")
def entry_reversed_by_admin(qa):
    def go():
        qa.original_entry = qa.entry
        qa.api = books.post(f"/journal-entries/{qa.entry['id']}/reverse", None, token=books.admin_token)
        if qa.api["status"] < 300:
            qa.reversal = qa.api["body"]
    act(qa, go)


@given(parsers.parse("the balance of account {account_id:d} is noted"))
def balance_noted(qa, account_id):
    if qa.store:
        qa.noted["bal." + str(account_id)] = qa.store.account_balance(account_id)


# ---------------------------------------------------------------- schema (throwaway)


@then(parsers.re(r"^the store has tables (?P<lst>.+)$"))
def store_has_tables(qa, lst):
    want = [t.strip() for t in lst.split(",")]

    def ev():
        have = qa.store.tables()
        missing = [t for t in want if t not in have]
        return (not missing, "missing " + ", ".join(missing) if missing else f"{len(have)} tables")
    check(qa, "store has the documented tables", ev)


@given("a throwaway database with the schema applied")
def throwaway_db(qa):
    qa.tmp = throwaway()
    qa.tmp.execute("INSERT INTO users (id, name, token, created_at) VALUES (1, 'U', 'tok', 1)")
    qa.tmp.execute("INSERT INTO accounts (id, code, name, type, currency, active, created_at) VALUES (1, '1000', 'Cash', 'asset', 'USD', 1, 1), (2, '2000', 'AP', 'liability', 'USD', 1, 1)")
    qa.tmp.execute("INSERT INTO journal_entries (id, entry_no, entry_date, memo, status, reverses_id, idempotency_key, created_at) VALUES (1, 1, '2024-01-03', 'm', 'posted', NULL, 'k1', 1)")
    qa.tmp.execute("INSERT INTO lines (id, entry_id, account_id, side, amount_cents, created_at) VALUES (1, 1, 1, 'debit', 100, 1), (2, 1, 2, 'credit', 100, 1)")


@given("a throwaway database with the schema and seed applied")
def throwaway_seeded(qa):
    qa.tmp = throwaway()
    qa.tmp.executescript(SEED.read_text(encoding="utf-8"))


def _fails(db, sql, params, needle):
    try:
        db.execute(sql, params)
        return (False, "insert succeeded")
    except sqlite3.Error as err:
        return (needle in str(err), str(err))


@then(parsers.parse('inserting an account with type "{t}" fails a CHECK'))
def acct_type_check(qa, t):
    qa.observe("account type CHECK", lambda: _fails(qa.tmp, "INSERT INTO accounts (code, name, type, currency, created_at) VALUES ('9999', 'X', ?, 'USD', 1)", (t,), "CHECK constraint failed"))


@then("inserting a line for a missing entry fails a FOREIGN KEY")
def line_missing_entry(qa):
    qa.observe("lines.entry_id FK", lambda: _fails(qa.tmp, "INSERT INTO lines (entry_id, account_id, side, amount_cents, created_at) VALUES (999, 1, 'debit', 10, 1)", (), "FOREIGN KEY constraint failed"))


@then("inserting a line for a missing account fails a FOREIGN KEY")
def line_missing_account(qa):
    qa.observe("lines.account_id FK", lambda: _fails(qa.tmp, "INSERT INTO lines (entry_id, account_id, side, amount_cents, created_at) VALUES (1, 999, 'debit', 10, 1)", (), "FOREIGN KEY constraint failed"))


@then(parsers.parse('inserting a line with side "{s}" fails a CHECK'))
def line_side_check(qa, s):
    qa.observe("line side CHECK", lambda: _fails(qa.tmp, "INSERT INTO lines (entry_id, account_id, side, amount_cents, created_at) VALUES (1, 1, ?, 10, 1)", (s,), "CHECK constraint failed"))


@then("inserting a line with a zero amount fails a CHECK")
def line_zero_amount(qa):
    qa.observe("amount_cents > 0", lambda: _fails(qa.tmp, "INSERT INTO lines (entry_id, account_id, side, amount_cents, created_at) VALUES (1, 1, 'debit', 0, 1)", (), "CHECK constraint failed"))


@then(parsers.parse('inserting an entry with status "{s}" fails a CHECK'))
def entry_status_check(qa, s):
    qa.observe("entry status CHECK", lambda: _fails(qa.tmp, "INSERT INTO journal_entries (entry_no, entry_date, status, created_at) VALUES (2, '2024-01-03', ?, 1)", (s,), "CHECK constraint failed"))


@then("inserting an account with active flag 2 fails a CHECK")
def acct_active_check(qa):
    qa.observe("active IN (0,1)", lambda: _fails(qa.tmp, "INSERT INTO accounts (code, name, type, currency, active, created_at) VALUES ('9998', 'X', 'asset', 'USD', 2, 1)", (), "CHECK constraint failed"))


@then("inserting two entries with the same entry number fails on the second")
def entry_no_unique(qa):
    def ev():
        a = _fails(qa.tmp, "INSERT INTO journal_entries (entry_no, entry_date, created_at) VALUES (5, '2024-01-03', 1)", (), "never")
        if a[1] != "insert succeeded":
            return (False, "first: " + a[1])
        return _fails(qa.tmp, "INSERT INTO journal_entries (entry_no, entry_date, created_at) VALUES (5, '2024-01-03', 1)", (), "UNIQUE constraint failed")
    qa.observe("entry_no UNIQUE", ev)


@then("inserting two accounts with the same code fails on the second")
def acct_code_unique(qa):
    def ev():
        a = _fails(qa.tmp, "INSERT INTO accounts (code, name, type, currency, created_at) VALUES ('7777', 'X', 'asset', 'USD', 1)", (), "never")
        if a[1] != "insert succeeded":
            return (False, "first: " + a[1])
        return _fails(qa.tmp, "INSERT INTO accounts (code, name, type, currency, created_at) VALUES ('7777', 'Y', 'asset', 'USD', 1)", (), "UNIQUE constraint failed")
    qa.observe("account code UNIQUE", ev)


@then("inserting two entries with the same idempotency key fails on the second")
def entry_idem_unique(qa):
    def ev():
        a = _fails(qa.tmp, "INSERT INTO journal_entries (entry_no, entry_date, idempotency_key, created_at) VALUES (8, '2024-01-03', 'DUP', 1)", (), "never")
        if a[1] != "insert succeeded":
            return (False, "first: " + a[1])
        return _fails(qa.tmp, "INSERT INTO journal_entries (entry_no, entry_date, idempotency_key, created_at) VALUES (9, '2024-01-03', 'DUP', 1)", (), "UNIQUE constraint failed")
    qa.observe("entry idempotency_key UNIQUE", ev)


@then("applying the seed again changes no row counts")
def seed_idempotent(qa):
    def ev():
        tables = ["users", "accounts", "journal_entries", "lines"]
        before = [qa.tmp.execute("SELECT COUNT(*) FROM " + t).fetchone()[0] for t in tables]
        qa.tmp.executescript(SEED.read_text(encoding="utf-8"))
        after = [qa.tmp.execute("SELECT COUNT(*) FROM " + t).fetchone()[0] for t in tables]
        return (before == after, f"before {json.dumps(before)}, after {json.dumps(after)}")
    qa.observe("seed idempotent", ev)


# ---------------------------------------------------------------- ledger-wide


@then("the whole ledger is balanced")
def whole_ledger_balanced(qa):
    def ev():
        g = qa.store.grand_totals()
        return (g["debit"] == g["credit"], f"debit {g['debit']}, credit {g['credit']}")
    check(qa, "grand debits == grand credits", ev)


@then("the chart of accounts has an account of every type")
def chart_every_type(qa):
    def ev():
        types = ["asset", "liability", "equity", "revenue", "expense"]
        missing = [t for t in types if qa.store.count("accounts", "WHERE type = ?", t) == 0]
        return (not missing, "missing " + ",".join(missing) if missing else "all five present")
    check(qa, "chart covers five types", ev)


# ---------------------------------------------------------------- per-entry


@then(parsers.parse("entry number {no:d} has exactly two lines"))
def entry_no_two_lines(qa, no):
    def ev():
        e = qa.store.get("SELECT id FROM journal_entries WHERE entry_no = ?", no)
        n = len(qa.store.lines(e["id"]))
        return (n == 2, f"{n} lines")
    check(qa, f"entry {no} has two lines", ev)


@then(parsers.parse("entry number {no:d}'s debit and credit lines are equal"))
def entry_no_balances(qa, no):
    def ev():
        e = qa.store.get("SELECT id FROM journal_entries WHERE entry_no = ?", no)
        return _entry_balanced(qa.store, e["id"])
    check(qa, f"entry {no} balances", ev)


@then("the entry's debit and credit lines are equal")
def entry_balances(qa):
    check(qa, "entry balances", lambda: _entry_balanced(qa.store, qa.entry["id"]))


@then("the entry has exactly two lines")
def entry_two_lines(qa):
    def ev():
        n = len(qa.store.lines(qa.entry["id"]))
        return (n == 2, f"{n} lines")
    check(qa, "entry has two lines", ev)


@then(parsers.parse("the debit line hits account {dr:d} and the credit line hits account {cr:d}"))
def debit_credit_accounts(qa, dr, cr):
    def ev():
        ls = qa.store.lines(qa.entry["id"])
        d = next((l for l in ls if l["side"] == "debit"), None)
        c = next((l for l in ls if l["side"] == "credit"), None)
        ok = bool(d) and bool(c) and d["account_id"] == dr and c["account_id"] == cr
        return (ok, f"debit acct {d['account_id'] if d else None}, credit acct {c['account_id'] if c else None}")
    check(qa, f"debit {dr}, credit {cr}", ev)


# ---------------------------------------------------------------- balances (delta)


def _balance_delta(qa, account_id, delta):
    def ev():
        now = qa.store.account_balance(account_id)
        before = qa.noted["bal." + str(account_id)]
        return (now - before == delta, f"before {before}, now {now}, change {now - before}")
    check(qa, f"account {account_id} moved by {delta}", ev)


@then(parsers.parse("account {account_id:d} balance rose by {delta:d}"))
def account_balance_rose(qa, account_id, delta):
    _balance_delta(qa, account_id, delta)


@then(parsers.parse("account {account_id:d} balance fell by {delta:d}"))
def account_balance_fell(qa, account_id, delta):
    _balance_delta(qa, account_id, -delta)


# ---------------------------------------------------------------- numbering & idempotency


@then(parsers.parse("the entry number is at least {n:d}"))
def entry_number_at_least(qa, n):
    check(qa, "entry_no >= " + str(n), lambda: (bool(qa.entry) and qa.entry["entry_no"] >= n, "entry_no " + str(qa.entry["entry_no"] if qa.entry else None)))


@then("the entry numbers run without a gap")
def entry_numbers_gapless(qa):
    def ev():
        mx = qa.store.get("SELECT COALESCE(MAX(entry_no),0) AS n FROM journal_entries")["n"]
        cnt = qa.store.count("journal_entries")
        return (mx == cnt, f"max {mx}, count {cnt}")
    check(qa, "entry numbers gapless", ev)


@then("only one entry carries that idempotency key")
def one_entry_per_key(qa):
    def ev():
        same = qa.first_entry["body"]["id"] == qa.second_entry["body"]["id"]
        return (same, f"first {qa.first_entry['body']['id']}, second {qa.second_entry['body']['id']}")
    check(qa, "one entry per key", ev)


# ---------------------------------------------------------------- reversals


@then("the reversal's lines are the original's with sides swapped")
def reversal_swaps_sides(qa):
    def ev():
        orig = sorted([(l["account_id"], l["side"], l["amount_cents"]) for l in qa.store.lines(qa.original_entry["id"])])
        rev = sorted([(l["account_id"], "credit" if l["side"] == "debit" else "debit", l["amount_cents"]) for l in qa.store.lines(qa.reversal["id"])])
        return (orig == rev, f"orig {json.dumps(orig)} rev(swapped) {json.dumps(rev)}")
    check(qa, "reversal swaps sides", ev)


@then("the original entry row is reversed")
def original_entry_reversed(qa):
    def ev():
        e = qa.store.get("SELECT status FROM journal_entries WHERE id = ?", qa.original_entry["id"])
        return (e["status"] == "reversed", e["status"])
    check(qa, "original status reversed", ev)


# ---------------------------------------------------------------- integrity


@then("no lines row references an entry missing from journal_entries")
def no_orphan_line_entry(qa):
    def ev():
        n = qa.store.count("lines l", "WHERE NOT EXISTS (SELECT 1 FROM journal_entries e WHERE e.id = l.entry_id)")
        return (n == 0, f"{n} orphans")
    check(qa, "no orphan line->entry", ev)


@then("no lines row references an account missing from accounts")
def no_orphan_line_account(qa):
    def ev():
        n = qa.store.count("lines l", "WHERE NOT EXISTS (SELECT 1 FROM accounts a WHERE a.id = l.account_id)")
        return (n == 0, f"{n} orphans")
    check(qa, "no orphan line->account", ev)


@then("every entry in the store has at least two lines")
def every_entry_two_lines(qa):
    def ev():
        bad = qa.store.all("SELECT e.id, COUNT(l.id) AS n FROM journal_entries e LEFT JOIN lines l ON l.entry_id = e.id GROUP BY e.id HAVING n < 2")
        return (len(bad) == 0, "bad " + json.dumps(bad) if bad else "all >= 2")
    check(qa, "every entry >= 2 lines", ev)


@then("every entry's debits equal its credits")
def every_entry_balances(qa):
    def ev():
        bad = qa.store.all("SELECT entry_id, SUM(CASE WHEN side='debit' THEN amount_cents ELSE -amount_cents END) AS net FROM lines GROUP BY entry_id HAVING net <> 0")
        return (len(bad) == 0, "unbalanced " + json.dumps(bad) if bad else "all balanced")
    check(qa, "every entry balances", ev)

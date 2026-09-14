"""HTTP client for the mini-books service. Mirror of node/be/api/venues/books.js.
urllib only. A transport failure is ApiUnreachable (grades Blocked); a 4xx/5xx is
an answer, often the one under test.

The convenience helpers post common bookkeeping entries (a cash sale, paying rent,
an owner investment) so a step can build up a set of books to report on. Account
ids come from the seeded chart of accounts (ACC).
"""

from __future__ import annotations

import json
import os
import urllib.error
import urllib.request

BASE = os.environ.get("MINI_BOOKS_URL", "http://127.0.0.1:8170").rstrip("/")
ADMIN_TOKEN = os.environ.get("MINI_BOOKS_ADMIN_TOKEN", "admin-token")
SEED_BOOK = "usr_seed_book"
SEED_AUX = "usr_seed_aux"
# Seeded chart of accounts ids (see db/seed.sql).
ACC = {
    "CASH": 1, "BANK": 2, "AR": 3, "INVENTORY": 4,
    "AP": 5, "LOAN": 6, "OWNER_CAPITAL": 7, "RETAINED": 8,
    "SALES": 9, "SERVICE": 10, "RENT": 11, "SALARIES": 12, "SUPPLIES": 13, "UTILITIES": 14,
    "CASH_EUR": 15, "ARCHIVED": 16,
}
BIZ_DAY = "2024-01-03"  # a Wednesday -- a safe default posting date


class ApiUnreachable(Exception):
    pass


class MiniBooks:
    def __init__(self, base: str = BASE) -> None:
        self.base = base
        self.admin_token = ADMIN_TOKEN
        self.seed_book = SEED_BOOK
        self.seed_aux = SEED_AUX
        self.acc = ACC
        self.biz_day = BIZ_DAY

    def request(self, method, path, token=None, body=None, headers=None):
        h = dict(headers or {})
        if token:
            h["Authorization"] = "Bearer " + token
        data = None
        if body is not None:
            h["Content-Type"] = "application/json"
            data = json.dumps(body).encode()
        req = urllib.request.Request(self.base + path, data=data, headers=h, method=method)
        try:
            with urllib.request.urlopen(req, timeout=15) as res:
                status, text = res.status, res.read().decode("utf-8", "replace")
                resp_headers = {k.lower(): v for k, v in res.headers.items()}
        except urllib.error.HTTPError as err:
            status, text = err.code, err.read().decode("utf-8", "replace")
            resp_headers = {k.lower(): v for k, v in (err.headers or {}).items()}
        except (urllib.error.URLError, TimeoutError, OSError) as err:
            raise ApiUnreachable(f"mini-books at {self.base} did not answer {method} {path}: {err}") from err
        try:
            parsed = json.loads(text) if text else None
        except json.JSONDecodeError:
            parsed = None
        return {"status": status, "headers": resp_headers, "body": parsed, "text": text}

    def get(self, p, **kw):
        return self.request("GET", p, **kw)

    def post(self, p, body=None, **kw):
        return self.request("POST", p, body=body, **kw)

    def new_user(self, name="Accountant"):
        r = self.post("/users", {"name": name})
        if r["status"] != 201:
            raise RuntimeError("create user failed: HTTP " + str(r["status"]) + " " + r["text"])
        return r["body"]

    def entry(self, token, dr, cr, amount, date=None, memo=None, key=None):
        """Post a two-line entry: debit ``dr``, credit ``cr``, for ``amount`` cents. Returns the response."""
        body = {
            "entry_date": date or BIZ_DAY,
            "memo": memo,
            "lines": [
                {"account_id": dr, "side": "debit", "amount_cents": amount},
                {"account_id": cr, "side": "credit", "amount_cents": amount},
            ],
        }
        if key:
            body["idempotency_key"] = key
        return self.post("/journal-entries", body, token=token)

    def post_entry(self, token, dr, cr, amount, **opts):
        """Post an entry and raise on a non-2xx; returns the entry body."""
        r = self.entry(token, dr, cr, amount, **opts)
        if r["status"] not in (201, 200):
            raise RuntimeError("post entry failed: HTTP " + str(r["status"]) + " " + r["text"])
        return r["body"]

    # named bookkeeping transactions, each a balanced entry
    def cash_sale(self, token, amount, **opts):
        return self.post_entry(token, ACC["CASH"], ACC["SALES"], amount, **opts)  # Dr Cash / Cr Sales

    def pay_rent(self, token, amount, **opts):
        return self.post_entry(token, ACC["RENT"], ACC["CASH"], amount, **opts)  # Dr Rent Expense / Cr Cash

    def owner_invest(self, token, amount, **opts):
        return self.post_entry(token, ACC["CASH"], ACC["OWNER_CAPITAL"], amount, **opts)

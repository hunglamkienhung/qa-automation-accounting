"""Steps for be-mini-books-journal.feature. Mirror of node/be/api/steps/journal.steps.js
-- a plugin module. The generic "refused with code/status" steps live here and are
shared across every @books @api tier. The @books Before/After setup and the "store is
open" Background live in be/db/steps/books_steps.py.
"""

from __future__ import annotations

import json

from pytest_bdd import parsers, then, when

from be.api.venues.books import ApiUnreachable, MiniBooks

books = MiniBooks()


def act(qa, fn):
    if qa.source_error:
        return None
    try:
        return fn()
    except ApiUnreachable as err:
        qa.source_error = str(err)
        return None


def check(qa, description, fn):
    if qa.source_error:
        qa.unobservable(description, "the source could not be reached -- " + qa.source_error)
        return
    passed, detail = fn()
    qa.check(description, passed, detail)


def _two_line(dr, cr, amt):
    return [{"account_id": dr, "side": "debit", "amount_cents": amt}, {"account_id": cr, "side": "credit", "amount_cents": amt}]


def post_lines(qa, lines, token, date=None, key=None):
    body = {"entry_date": date or books.biz_day, "lines": lines}
    if key:
        body["idempotency_key"] = key

    def go():
        qa.api = books.post("/journal-entries", body, token=token) if token else books.post("/journal-entries", body)
        if qa.api["status"] in (201, 200):
            qa.entry = qa.api["body"]
    act(qa, go)


# ---------------------------------------------------------------- Whens


@when(parsers.re(r"^the accountant posts Dr account (?P<dr>\d+) Cr account (?P<cr>\d+) for (?P<amt>-?\d+)$"))
def posts_dr_cr(qa, dr, cr, amt):
    post_lines(qa, _two_line(int(dr), int(cr), int(amt)), qa.token)


@when(parsers.re(r"^the accountant posts Dr account (?P<dr>\d+) Cr account (?P<cr>\d+) for (?P<amt>-?\d+) dated (?P<date>\S+)$"))
def posts_dr_cr_dated(qa, dr, cr, amt, date):
    post_lines(qa, _two_line(int(dr), int(cr), int(amt)), qa.token, date=date)


@when(parsers.parse("the accountant posts a split entry debiting account {d1:d} by {a1:d} and account {d2:d} by {a2:d} crediting account {cr:d} by {ac:d}"))
def posts_split(qa, d1, a1, d2, a2, cr, ac):
    lines = [
        {"account_id": d1, "side": "debit", "amount_cents": a1},
        {"account_id": d2, "side": "debit", "amount_cents": a2},
        {"account_id": cr, "side": "credit", "amount_cents": ac},
    ]
    post_lines(qa, lines, qa.token)


@when(parsers.parse("the accountant posts an unbalanced entry of Dr {dr:d} Cr {cr:d}"))
def posts_unbalanced(qa, dr, cr):
    post_lines(qa, [{"account_id": 1, "side": "debit", "amount_cents": dr}, {"account_id": 9, "side": "credit", "amount_cents": cr}], qa.token)


@when("the accountant posts a single-line entry")
def posts_single_line(qa):
    post_lines(qa, [{"account_id": 1, "side": "debit", "amount_cents": 1000}], qa.token)


@when(parsers.re(r"^an anonymous caller posts Dr account (?P<dr>\d+) Cr account (?P<cr>\d+) for (?P<amt>-?\d+)$"))
def anon_posts(qa, dr, cr, amt):
    post_lines(qa, _two_line(int(dr), int(cr), int(amt)), None)


@when(parsers.re(r"^a forged token posts Dr account (?P<dr>\d+) Cr account (?P<cr>\d+) for (?P<amt>-?\d+)$"))
def forged_posts(qa, dr, cr, amt):
    post_lines(qa, _two_line(int(dr), int(cr), int(amt)), "usr_forged000000000000000000")


@when(parsers.re(r'^the accountant posts Dr account (?P<dr>\d+) Cr account (?P<cr>\d+) for (?P<amt>-?\d+) with key "(?P<key>[^"]+)"$'))
def posts_with_key(qa, dr, cr, amt, key):
    lines = _two_line(int(dr), int(cr), int(amt))
    post_lines(qa, lines, qa.token, key=key)
    qa.first_entry = qa.api
    qa.last_lines = lines


@when(parsers.parse('the accountant posts again with key "{key}"'))
def posts_again_with_key(qa, key):
    def go():
        qa.api = books.post("/journal-entries", {"entry_date": books.biz_day, "lines": qa.last_lines, "idempotency_key": key}, token=qa.token)
        qa.second_entry = qa.api
    act(qa, go)


@when("the accountant reads the entry")
def reads_entry(qa):
    act(qa, lambda: qa.__setattr__("api", books.get("/journal-entries/" + str(qa.entry["id"]), token=qa.token)))


@when("the accountant lists the entries")
def lists_entries(qa):
    act(qa, lambda: qa.__setattr__("api", books.get("/journal-entries", token=qa.token)))


# ---------------------------------------------------------------- Thens


@then("the entry is posted")
def entry_is_posted(qa):
    check(qa, "entry posted", lambda: (bool(qa.api) and qa.api["status"] == 201, f"{qa.api['status']} {json.dumps(qa.api['body'])}" if qa.api else "no response"))


@then("the entry is refused")
def entry_is_refused(qa):
    check(qa, "entry refused", lambda: (bool(qa.api) and qa.api["status"] >= 400, f"{qa.api['status']} {json.dumps(qa.api['body'])}" if qa.api else "no response"))


@then("the entry response balances")
def entry_response_balances(qa):
    def ev():
        e = qa.entry
        if not e or not e.get("lines"):
            return (False, f"{qa.api['status']} {json.dumps(qa.api['body'])}" if qa.api else "no entry")
        d = sum(l["amount_cents"] for l in e["lines"] if l["side"] == "debit")
        c = sum(l["amount_cents"] for l in e["lines"] if l["side"] == "credit")
        return (len(e["lines"]) >= 2 and d == c, f"debit {d}, credit {c}")
    check(qa, "entry response balances", ev)


@then("the entry has a number")
def entry_has_number(qa):
    check(qa, "entry has a number", lambda: (bool(qa.entry) and isinstance(qa.entry.get("entry_no"), int) and qa.entry["entry_no"] >= 1, "entry_no " + str(qa.entry.get("entry_no") if qa.entry else None)))


@then(parsers.parse("the entry lists {n:d} lines"))
def entry_lists_n_lines(qa, n):
    check(qa, "entry lists " + str(n) + " lines", lambda: (bool(qa.entry) and len(qa.entry["lines"]) == n, (str(len(qa.entry["lines"])) + " lines") if qa.entry else "no entry"))


@then("the entry reads back with balanced lines")
def entry_reads_back(qa):
    def ev():
        e = qa.api and qa.api["body"]
        if not e or not e.get("lines"):
            return (False, "no body")
        d = sum(l["amount_cents"] for l in e["lines"] if l["side"] == "debit")
        c = sum(l["amount_cents"] for l in e["lines"] if l["side"] == "credit")
        return (d == c, f"debit {d}, credit {c}")
    check(qa, "entry reads back balanced", ev)


@then("the entry list includes the posted entry")
def entry_list_includes(qa):
    def ev():
        es = qa.api and qa.api["body"] and qa.api["body"].get("entries")
        return (isinstance(es, list) and any(e["id"] == qa.entry["id"] for e in es), (str(len(es)) + " entries") if es else "no list")
    check(qa, "entry list includes posted", ev)


@then("both posts are the same entry")
def both_posts_same(qa):
    def ev():
        a = qa.first_entry and qa.first_entry["body"]
        b = qa.second_entry and qa.second_entry["body"]
        return (bool(a) and bool(b) and a["id"] == b["id"], f"first {a['id'] if a else None}, second {b['id'] if b else None}")
    check(qa, "idempotent post same entry", ev)


# ---- generic refusals, shared across @books @api tiers ----


@then(parsers.parse('the request is refused with code "{code}"'))
def refused_with_code(qa, code):
    def ev():
        ok = bool(qa.api) and qa.api["status"] >= 400 and qa.api["body"] and qa.api["body"].get("code") == code
        return (ok, f"{qa.api['status']} {json.dumps(qa.api['body'])}" if qa.api else "no response")
    check(qa, "refused with code " + code, ev)


@then(parsers.parse("the request is refused with status {status:d}"))
def refused_with_status(qa, status):
    check(qa, "refused with status " + str(status), lambda: (bool(qa.api) and qa.api["status"] == status, f"{qa.api['status']} {json.dumps(qa.api['body'])}" if qa.api else "no response"))

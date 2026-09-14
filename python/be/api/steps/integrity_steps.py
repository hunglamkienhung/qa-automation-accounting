"""Steps for be-mini-books-integrity.feature -- the accounting equation, reversals,
and gapless numbering under concurrency. Mirror of node/be/api/steps/integrity.steps.js
-- a plugin module.

The race steps fire N posts at once with a ThreadPoolExecutor (each thread makes its
own fresh urllib request): distinct entries must all succeed and be numbered gaplessly,
or a shared key must collapse to one entry. The service serializes numbering inside one
BEGIN IMMEDIATE + MAX(entry_no)+1 transaction, so both invariants hold. Setup Givens (a
cash sale, the entry is reversed by the admin, the books figures are noted) and several
assertions are shared from the db and reports steps. The generic "refused with
code/status" steps live in journal_steps.py.
"""

from __future__ import annotations

import json
from concurrent.futures import ThreadPoolExecutor

from pytest_bdd import parsers, then, when

from be.api.venues.books import ApiUnreachable, MiniBooks

books = MiniBooks()
# Module-level counter, mirroring the node IDEM counter: a per-scenario unique key.
_IDEM = [0]


def _two_line(dr, cr, amt):
    return [{"account_id": dr, "side": "debit", "amount_cents": amt}, {"account_id": cr, "side": "credit", "amount_cents": amt}]


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


def figures(qa):
    bs = books.get("/reports/balance-sheet", token=qa.token)["body"]
    is_ = books.get("/reports/income-statement", token=qa.token)["body"]
    return {"assets": bs["assets"], "liabilities": bs["liabilities"], "equity": bs["equity"], "net_income": bs["net_income"], "revenue": is_["revenue"], "expenses": is_["expenses"]}


# ---------------------------------------------------------------- reversals


@when("the admin reverses the entry")
def admin_reverses_entry(qa):
    act(qa, lambda: qa.__setattr__("api", books.post(f"/journal-entries/{qa.entry['id']}/reverse", None, token=books.admin_token)))


@when("the admin reverses the reversal")
def admin_reverses_reversal(qa):
    act(qa, lambda: qa.__setattr__("api", books.post(f"/journal-entries/{qa.reversal['id']}/reverse", None, token=books.admin_token)))


@when("the accountant tries to reverse the entry")
def accountant_tries_reverse(qa):
    act(qa, lambda: qa.__setattr__("api", books.post(f"/journal-entries/{qa.entry['id']}/reverse", None, token=qa.token)))


@when(parsers.parse("the admin reverses entry {entry_id:d}"))
def admin_reverses_entry_id(qa, entry_id):
    act(qa, lambda: qa.__setattr__("api", books.post(f"/journal-entries/{entry_id}/reverse", None, token=books.admin_token)))


# ---------------------------------------------------------------- the races


@when(parsers.parse("{n:d} accountants post distinct entries at once"))
def race_distinct(qa, n):
    def real():
        qa.race_before = qa.store.count("journal_entries")

        def one(_):
            return books.post("/journal-entries", {"entry_date": books.biz_day, "lines": _two_line(books.acc["CASH"], books.acc["SALES"], 10)}, token=books.seed_book)

        with ThreadPoolExecutor(max_workers=n) as ex:
            results = list(ex.map(one, range(n)))
        qa.race_statuses = [r["status"] for r in results]
        qa.race_nos = [r["body"]["entry_no"] for r in results if r["body"] and r["body"].get("entry_no") is not None]
        qa.race_n = n
    act(qa, real)


@when(parsers.parse("{n:d} accountants post the same entry with one key at once"))
def race_idempotent(qa, n):
    key = "race-idem-" + str(_IDEM[0])
    _IDEM[0] += 1

    def real():
        def one(_):
            return books.post("/journal-entries", {"entry_date": books.biz_day, "lines": _two_line(books.acc["CASH"], books.acc["SALES"], 100), "idempotency_key": key}, token=books.seed_book)

        with ThreadPoolExecutor(max_workers=n) as ex:
            results = list(ex.map(one, range(n)))
        qa.race_ids = [r["body"]["id"] for r in results if r["body"] and r["body"].get("id") is not None]
        qa.race_n = n
    act(qa, real)


# ---------------------------------------------------------------- assertions


@then("the figures are back to what was noted")
def figures_restored(qa):
    if qa.source_error:
        qa.unobservable("figures restored", qa.source_error)
        return
    now = act(qa, lambda: figures(qa))
    check(qa, "figures restored after reversal", lambda: (bool(now) and json.dumps(now) == json.dumps(qa.noted_fig), "noted " + json.dumps(qa.noted_fig) + " now " + json.dumps(now)))


@then("every racing post succeeds")
def every_racing_post_succeeds(qa):
    def ev():
        s = qa.race_statuses or []
        ok = len([x for x in s if x == 201])
        return (ok == qa.race_n, f"{ok}/{len(s)} were 201")
    check(qa, "every racing post 201", ev)


@then("the entry numbers are gapless and unique")
def entry_numbers_gapless_unique(qa):
    def ev():
        mx = qa.store.get("SELECT COALESCE(MAX(entry_no),0) AS n FROM journal_entries")["n"]
        cnt = qa.store.count("journal_entries")
        uniq = len(set(qa.race_nos)) == len(qa.race_nos)
        return (mx == cnt and uniq and len(qa.race_nos) == qa.race_n, f"max {mx}, count {cnt}, {len(qa.race_nos)} nos, {len(set(qa.race_nos))} unique")
    check(qa, "entry numbers gapless and unique", ev)


@then(parsers.parse("{n:d} entries were added"))
def n_entries_added(qa, n):
    def ev():
        cnt = qa.store.count("journal_entries")
        return (cnt == qa.race_before + n, f"before {qa.race_before}, now {cnt}")
    check(qa, str(n) + " entries added", ev)


@then("all the racing posts share one entry")
def racing_posts_share_one(qa):
    def ev():
        ids = qa.race_ids or []
        uniq = set(ids)
        return (len(ids) == qa.race_n and len(uniq) == 1, f"{len(ids)} ids, {len(uniq)} unique")
    check(qa, "idempotent race one entry", ev)


@then(parsers.parse("the response status is {status:d}"))
def response_status_is(qa, status):
    check(qa, "response status " + str(status), lambda: (bool(qa.api) and qa.api["status"] == status, f"{qa.api['status']} {json.dumps(qa.api['body'])}" if qa.api else "no response"))

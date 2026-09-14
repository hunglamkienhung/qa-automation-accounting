"""Steps for be-mini-books-security.feature. Mirror of node/be/api/steps/security.steps.js
-- a plugin module. These probe the API's authorization boundaries -- no token, a
forged token, the wrong role. Setup Givens (an accountant, a cash sale) and "the
response status is {int}" are shared from the other @books steps; only the adversarial
requests and the secret-hygiene assertions are new. qa.api is always the last response.
"""

from __future__ import annotations

import json
import re

from pytest_bdd import parsers, then, when

from be.api.venues.books import ApiUnreachable, MiniBooks

books = MiniBooks()
FORGED = "usr_forged000000000000000000"


def _two_line(dr, cr, amt):
    return [{"account_id": dr, "side": "debit", "amount_cents": amt}, {"account_id": cr, "side": "credit", "amount_cents": amt}]


def send(qa, method, path, **opts):
    if qa.source_error:
        return
    try:
        qa.api = books.request(method, path, **opts)
    except ApiUnreachable as err:
        qa.source_error = str(err)


def check(qa, description, fn):
    if qa.source_error:
        qa.unobservable(description, "the source could not be reached -- " + qa.source_error)
        return
    passed, detail = fn()
    qa.check(description, passed, detail)


# A minted token is a JSON string value "usr_<...>"; match the quoted value, not
# the bare prefix, to avoid false positives on field names.
def leaks_token(obj, admin_token):
    text = json.dumps(obj or {})
    return re.search(r'"usr_[A-Za-z0-9_-]{8,}"', text) is not None or ('"' + admin_token + '"') in text


# ---------------------------------------------------------------- adversarial requests


@when("an entry is posted with no token")
def entry_no_token(qa):
    send(qa, "POST", "/journal-entries", body={"entry_date": books.biz_day, "lines": _two_line(1, 9, 1000)})


@when("an entry is posted with a forged token")
def entry_forged_token(qa):
    send(qa, "POST", "/journal-entries", token=FORGED, body={"entry_date": books.biz_day, "lines": _two_line(1, 9, 1000)})


@when(parsers.parse("entry {entry_id:d} is read with no token"))
def entry_read_no_token(qa, entry_id):
    send(qa, "GET", "/journal-entries/" + str(entry_id))


@when("the admin entry list is read with the accountant's token")
def admin_list_accountant(qa):
    send(qa, "GET", "/admin/entries", token=books.seed_book)


@when("the admin overview is read with the accountant's token")
def admin_overview_accountant(qa):
    send(qa, "GET", "/admin/overview", token=books.seed_book)


@when("the admin overview is read with a token that extends the admin token")
def admin_overview_extended(qa):
    send(qa, "GET", "/admin/overview", token=books.admin_token + "x")


@when("the trial balance is read with no token")
def trial_balance_no_token(qa):
    send(qa, "GET", "/reports/trial-balance")


@when("the chart of accounts is read with no token")
def accounts_no_token(qa):
    send(qa, "GET", "/accounts")


@when("an accountant registers")
def accountant_registers(qa):
    send(qa, "POST", "/users", body={"name": "Sec Accountant"})


# ---------------------------------------------------------------- generic assertions


@then(parsers.parse('the response is an error with code "{code}"'))
def response_error_code(qa, code):
    check(qa, "error code " + code, lambda: (bool(qa.api) and qa.api["body"] and qa.api["body"].get("code") == code, json.dumps(qa.api["body"]) if qa.api and qa.api["body"] else "no body"))


@then("the response carries a token")
def response_carries_token(qa):
    def ev():
        t = (qa.api and qa.api["body"] or {}).get("token")
        return (isinstance(t, str) and len(t) > 0, "token " + ("present" if t else "absent"))
    check(qa, "response carries a token", ev)


# ---------------------------------------------------------------- secret hygiene


@then("the entry response carries no bearer token")
def entry_no_bearer(qa):
    check(qa, "entry body has no token", lambda: (not leaks_token(qa.entry, books.admin_token), "TOKEN LEAKED" if leaks_token(qa.entry, books.admin_token) else "clean"))


@then("the accounts response carries no bearer token")
def accounts_no_bearer(qa):
    check(qa, "accounts body has no token", lambda: (not leaks_token(qa.api and qa.api["body"], books.admin_token), "TOKEN LEAKED" if leaks_token(qa.api and qa.api["body"], books.admin_token) else "clean"))


@then("the report response carries no bearer token")
def report_no_bearer(qa):
    check(qa, "report body has no token", lambda: (not leaks_token(qa.api and qa.api["body"], books.admin_token), "TOKEN LEAKED" if leaks_token(qa.api and qa.api["body"], books.admin_token) else "clean"))

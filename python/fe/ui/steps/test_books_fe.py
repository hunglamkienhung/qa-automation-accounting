"""The FE branch for the mini-books app surfaces. Binds ../../features/fe-mini-books.feature.
Mirror of node/fe/ui/steps/books.steps.js. The `page` fixture is pytest-playwright's;
the comparison figures come from the store (opened by the shared @books "store is open"
Background) and the rows, so the FE branch checks the pages against the same data the BE
branch reads. The accountant/cash-sale setup Givens are shared from the be steps.
"""

from __future__ import annotations

import json
import re

from pytest_bdd import given, parsers, scenarios, then, when

from be.api.venues.books import ApiUnreachable
from fe.ui.pages.books import BooksPage, ScreenNotReady

scenarios("fe-mini-books.feature")

UNREACHABLE = (ScreenNotReady, ApiUnreachable)


def money(cents):
    return f"{cents / 100:.2f}"


def num(s):
    return float(re.sub(r"[^0-9.\-]", "", str(s)))


def cents(s):
    # parse a dollar string back to integer cents for exact comparison
    return round(num(s) * 100)


def screen(qa, description, fn):
    if qa.source_error:
        qa.unobservable(description, "the source could not be reached -- " + qa.source_error)
        return
    try:
        passed, detail = fn()
    except UNREACHABLE as err:
        qa.unobservable(description, str(err))
        return
    qa.check(description, passed, detail)


# ---------------------------------------------------------------- entry / setup


@given("the home page is open")
def home_open(page, qa):
    page.set_viewport_size({"width": 1440, "height": 900})
    qa.books_page = BooksPage(page)

    def go():
        qa.books_page.open("/")
        qa.screen["accounts"] = qa.books_page.accounts()
    qa.fetch_or_block(UNREACHABLE, go)


# ---------------------------------------------------------------- navigation


def _open_read(qa, path, key, reader, extra=None):
    def go():
        qa.books_page.open(path)
        try:
            qa.screen[key] = reader()
        except ScreenNotReady:
            qa.screen[key] = None
        if extra:
            extra()
    qa.fetch_or_block(UNREACHABLE, go)


@when(parsers.parse("the account page for account {account_id:d} is opened"))
def account_page_opened(qa, account_id):
    _open_read(qa, "/account/" + str(account_id), "account", lambda: qa.books_page.account(), extra=lambda: qa.screen.__setitem__("accountId", account_id))


@when("the entry page is opened")
def entry_page_opened(qa):
    _open_read(qa, "/entry/" + str(qa.entry["id"]), "entry", lambda: qa.books_page.entry())


@when(parsers.parse("the entry page for {entry_id:d} is opened"))
def entry_page_for_opened(qa, entry_id):
    _open_read(qa, "/entry/" + str(entry_id), "entry", lambda: qa.books_page.entry())


@when("the trial balance page is opened")
def trial_balance_page_opened(qa):
    _open_read(qa, "/trial-balance", "tb", lambda: qa.books_page.trial_balance())


@when("the balance sheet page is opened")
def balance_sheet_page_opened(qa):
    _open_read(qa, "/balance-sheet", "bs", lambda: qa.books_page.balance_sheet())


@when("the admin page is opened")
def admin_page_opened(qa):
    _open_read(qa, "/admin", "admin", lambda: qa.books_page.admin())


# ---------------------------------------------------------------- chart of accounts


@then("the home page lists at least the sixteen seeded accounts")
def home_lists_sixteen(qa):
    def ev():
        ids = [a["id"] for a in qa.screen["accounts"]]
        missing = [i for i in range(1, 17) if i not in ids]
        return (not missing, "missing " + ",".join(map(str, missing)) if missing else str(len(ids)) + " accounts")
    screen(qa, "home lists seeded accounts", ev)


@then("every account row shows a code, a name and a type")
def rows_show_code_name_type(qa):
    def ev():
        bad = [a for a in qa.screen["accounts"] if not re.match(r"^\d{4}$", a["code"]) or not a["name"] or a["type"] not in ("asset", "liability", "equity", "revenue", "expense")]
        return (not bad and len(qa.screen["accounts"]) > 0, json.dumps(bad[:2]) if bad else str(len(qa.screen["accounts"])) + " rows")
    screen(qa, "account rows show code/name/type", ev)


@then("every account balance on screen is a number")
def balances_are_numbers(qa):
    def ev():
        bad = [a for a in qa.screen["accounts"] if not re.match(r"^-?\d+\.\d{2}$", a["balanceText"])]
        return (not bad, json.dumps([a["balanceText"] for a in bad[:2]]) if bad else "all numeric")
    screen(qa, "account balances are numbers", ev)


@then("the home page shows an account of every type")
def home_shows_every_type(qa):
    def ev():
        types = {a["type"] for a in qa.screen["accounts"]}
        want = ["asset", "liability", "equity", "revenue", "expense"]
        missing = [t for t in want if t not in types]
        return (not missing, "missing " + ",".join(missing) if missing else ",".join(types))
    screen(qa, "home shows five types", ev)


# ---------------------------------------------------------------- an account


@then("the account page balance equals the stored balance")
def account_balance_matches(qa):
    def ev():
        a = qa.screen.get("account")
        bal = qa.store.account_balance(qa.screen["accountId"])
        return (bool(a) and a["balanceText"] == money(bal), (a["balanceText"] + " vs " + money(bal)) if a else "no page")
    screen(qa, "account page balance == stored", ev)


@then(parsers.parse('the account page shows code "{code}" and type "{type_}"'))
def account_code_type(qa, code, type_):
    def ev():
        a = qa.screen.get("account")
        return (bool(a) and a["codeText"] == code and a["typeText"] == type_, (a["codeText"] + "/" + a["typeText"]) if a else "no page")
    screen(qa, "account page code/type", ev)


@then("the page reports not found")
def page_not_found(qa):
    def ev():
        txt = qa.books_page.page.text_content("body")
        return (re.search(r"no such", txt, re.I) is not None, txt[:60])
    screen(qa, "page not found", ev)


# ---------------------------------------------------------------- an entry


@then("the entry lines on screen show a debit and a credit of the same amount")
def entry_lines_balanced(qa):
    def ev():
        ls = qa.screen.get("entry") and qa.screen["entry"]["lines"]
        if not ls:
            return (False, "no page")
        d = next((l for l in ls if l["side"] == "debit"), None)
        c = next((l for l in ls if l["side"] == "credit"), None)
        return (bool(d) and bool(c) and len(ls) == 2 and d["amount"] == c["amount"], (f"debit {d['amount']}, credit {c['amount']}") if d and c else "missing a side")
    screen(qa, "entry lines balanced on screen", ev)


@then(parsers.parse('the entry page shows status "{status}"'))
def entry_page_status(qa, status):
    def ev():
        e = qa.screen.get("entry")
        return (bool(e) and e["statusText"] == status, e["statusText"] if e else "no page")
    screen(qa, "entry status " + status, ev)


# ---------------------------------------------------------------- reports


@then("the trial balance page shows the debits equal the credits")
def tb_debits_equal_credits(qa):
    def ev():
        t = qa.screen.get("tb")
        return (bool(t) and cents(t["debitsText"]) == cents(t["creditsText"]), (t["debitsText"] + " vs " + t["creditsText"]) if t else "no page")
    screen(qa, "trial balance debits == credits", ev)


@then("the trial balance page shows it balanced")
def tb_balanced(qa):
    def ev():
        t = qa.screen.get("tb")
        return (bool(t) and t["balancedText"] == "balanced", t["balancedText"] if t else "no page")
    screen(qa, "trial balance balanced", ev)


@then("the balance sheet page shows Assets equal Liabilities plus Equity plus Net income")
def bs_identity(qa):
    def ev():
        b = qa.screen.get("bs")
        if not b:
            return (False, "no page")
        return (cents(b["assetsText"]) == cents(b["liabilitiesText"]) + cents(b["equityText"]) + cents(b["netIncomeText"]), f"A {b['assetsText']} = L {b['liabilitiesText']} + E {b['equityText']} + NI {b['netIncomeText']}")
    screen(qa, "balance sheet identity on screen", ev)


@then("the balance sheet page shows it balanced")
def bs_balanced(qa):
    def ev():
        b = qa.screen.get("bs")
        return (bool(b) and b["balancedText"] == "balanced", b["balancedText"] if b else "no page")
    screen(qa, "balance sheet balanced", ev)


# ---------------------------------------------------------------- admin


@then("the admin page shows it balanced")
def admin_balanced(qa):
    def ev():
        a = qa.screen.get("admin")
        return (bool(a) and a["balancedText"] == "balanced", a["balancedText"] if a else "no page")
    screen(qa, "admin balanced", ev)


@then("the admin entry count is a positive integer")
def admin_entry_count(qa):
    def ev():
        a = qa.screen.get("admin")
        return (bool(a) and re.match(r"^\d+$", a["entriesText"]) is not None and int(a["entriesText"]) > 0, a["entriesText"] if a else "no page")
    screen(qa, "admin entry count", ev)

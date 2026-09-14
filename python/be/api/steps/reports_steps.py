"""Steps for be-mini-books-reports.feature. Mirror of node/be/api/steps/reports.steps.js
-- a plugin module. Report figures accumulate as the shared books grow, so figure
checks are on deltas (note the figures, post, check the change); the accounting
invariants (balanced, equation holds, net income = revenue - expenses) are absolute
because they hold no matter what else has posted. The "posts Dr .. Cr .." step is
shared from journal_steps.py.
"""

from __future__ import annotations

import json

from pytest_bdd import given, parsers, then, when

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


def figures(qa):
    bs = books.get("/reports/balance-sheet", token=qa.token)["body"]
    is_ = books.get("/reports/income-statement", token=qa.token)["body"]
    return {"assets": bs["assets"], "liabilities": bs["liabilities"], "equity": bs["equity"], "net_income": bs["net_income"], "revenue": is_["revenue"], "expenses": is_["expenses"]}


# ---------------------------------------------------------------- Whens


@when("the trial balance is fetched")
def trial_balance_fetched(qa):
    def go():
        qa.api = books.get("/reports/trial-balance", token=qa.token)
        qa.report = qa.api["body"]
    act(qa, go)


@when("the balance sheet is fetched")
def balance_sheet_fetched(qa):
    def go():
        qa.api = books.get("/reports/balance-sheet", token=qa.token)
        qa.report = qa.api["body"]
    act(qa, go)


@when("the income statement is fetched")
def income_statement_fetched(qa):
    def go():
        qa.api = books.get("/reports/income-statement", token=qa.token)
        qa.report = qa.api["body"]
    act(qa, go)


@when("the accounting equation is fetched")
def equation_fetched(qa):
    def go():
        qa.api = books.get("/reports/equation", token=qa.token)
        qa.report = qa.api["body"]
    act(qa, go)


@given("the books figures are noted")
@when("the books figures are noted")
def books_figures_noted(qa):
    def go():
        qa.noted_fig = figures(qa)
    act(qa, go)


# ---------------------------------------------------------------- Thens


@then("the trial balance is balanced")
def trial_balance_balanced(qa):
    def ev():
        r = qa.report
        return (bool(r) and r["balanced"] is True and r["total_debits"] == r["total_credits"], f"Dr {r['total_debits']} Cr {r['total_credits']}" if r else "no report")
    check(qa, "trial balance balanced", ev)


@then("the balance sheet balances")
def balance_sheet_balances(qa):
    def ev():
        r = qa.report
        return (bool(r) and r["balanced"] is True and r["assets"] == r["liabilities"] + r["equity"] + r["net_income"], json.dumps(r) if r else "no report")
    check(qa, "balance sheet balances", ev)


@then("net income equals revenue minus expenses")
def net_income_rev_exp(qa):
    def ev():
        r = qa.report
        return (bool(r) and r["net_income"] == r["revenue"] - r["expenses"], json.dumps(r) if r else "no report")
    check(qa, "net income = rev - exp", ev)


@then("the accounting equation holds")
def equation_holds(qa):
    def ev():
        r = qa.report
        return (bool(r) and r["holds"] is True and r["assets"] == r["liabilities"] + r["equity"] + r["revenue"] - r["expenses"], json.dumps(r) if r else "no report")
    check(qa, "accounting equation holds", ev)


@then("the balance sheet still balances")
def balance_sheet_still_balances(qa):
    if qa.source_error:
        qa.unobservable("balance sheet still balances", qa.source_error)
        return
    b = act(qa, lambda: books.get("/reports/balance-sheet", token=qa.token))
    check(qa, "balance sheet still balances", lambda: (bool(b) and b["body"] and b["body"]["balanced"] is True, json.dumps(b["body"]) if b and b["body"] else "no read"))


@then("the accounting equation still holds")
def equation_still_holds(qa):
    if qa.source_error:
        qa.unobservable("equation still holds", qa.source_error)
        return
    e = act(qa, lambda: books.get("/reports/equation", token=qa.token))
    check(qa, "equation still holds", lambda: (bool(e) and e["body"] and e["body"]["holds"] is True, json.dumps(e["body"]) if e and e["body"] else "no read"))


@then(parsers.parse("the trial balance shows account {account_id:d} with a debit balance"))
def tb_debit_row(qa, account_id):
    def ev():
        code_by_id = {1: "1000", 7: "3000"}
        code = code_by_id.get(account_id)
        row = next((r for r in ((qa.report and qa.report.get("rows")) or []) if r["code"] == code), None)
        return (bool(row) and row["debit"] > 0 and row["credit"] == 0, json.dumps(row) if row else "no row for " + str(code))
    check(qa, "trial balance debit row", ev)


@then(parsers.parse("the trial balance shows account {account_id:d} with a credit balance"))
def tb_credit_row(qa, account_id):
    def ev():
        code_by_id = {7: "3000", 1: "1000"}
        code = code_by_id.get(account_id)
        row = next((r for r in ((qa.report and qa.report.get("rows")) or []) if r["code"] == code), None)
        return (bool(row) and row["credit"] > 0 and row["debit"] == 0, json.dumps(row) if row else "no row for " + str(code))
    check(qa, "trial balance credit row", ev)


# ---- figure deltas ----


def _figure_delta(qa, key, delta):
    if qa.source_error:
        qa.unobservable(f"{key} moved by {delta}", qa.source_error)
        return
    now_fig = act(qa, lambda: figures(qa))
    check(qa, f"reported {key} moved by {delta}", lambda: ((now_fig[key] - qa.noted_fig[key]) == delta, f"before {qa.noted_fig[key]}, now {now_fig[key]}, change {now_fig[key] - qa.noted_fig[key]}"))


@then(parsers.re(r"^reported (?P<word>\w+) rose by (?P<n>\d+)$"))
def reported_word_rose(qa, word, n):
    _figure_delta(qa, word, int(n))


@then(parsers.re(r"^reported (?P<word>\w+) fell by (?P<n>\d+)$"))
def reported_word_fell(qa, word, n):
    _figure_delta(qa, word, -int(n))


@then(parsers.parse("reported net income rose by {n:d}"))
def reported_ni_rose(qa, n):
    _figure_delta(qa, "net_income", n)


@then(parsers.parse("reported net income fell by {n:d}"))
def reported_ni_fell(qa, n):
    _figure_delta(qa, "net_income", -n)

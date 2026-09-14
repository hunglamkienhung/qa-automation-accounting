"""Steps for be-nager-api.feature. Mirror of node/be/api/steps/nager.steps.js
-- a plugin module. The business-day steps are pure and deterministic. The live
steps read Nager.Date; a transport failure sets source_error and grades Blocked.
One flow feeds a real holiday list into the business-day rule to compute a
settlement date -- the date a business would post or settle on -- skipping
weekends and public holidays, end to end.
"""

from __future__ import annotations

import json

import pytest
from pytest_bdd import parsers, then, when

from be.api.venues import nager


@pytest.fixture(autouse=True)
def nager_scenario(request, qa):
    if request.node.get_closest_marker("nager") is None:
        yield
        return
    qa.weekend = None
    qa.business_day = None
    qa.hol = None
    qa.hol2 = None
    qa.countries = None
    qa.settle = None
    qa.settle_from = None
    qa.hol_set = None
    yield


def live(qa, fn):
    if qa.source_error:
        return None
    try:
        return fn()
    except nager.NagerUnreachable as err:
        qa.source_error = str(err)
        return None


def check(qa, description, fn):
    if qa.source_error:
        qa.unobservable(description, "the source could not be reached -- " + qa.source_error)
        return
    passed, detail = fn()
    qa.check(description, passed, detail)


# ---------------------------------------------------------------- pure business-day rule


@when(parsers.re(r"^the weekend flag of (?P<date>\S+) is checked$"))
def weekend_flag_checked(qa, date):
    qa.weekend = nager.is_weekend(date)


@when(parsers.re(r"^the business day after (?P<date>\S+) is computed with no holidays$"))
def business_day_no_holidays(qa, date):
    qa.business_day = nager.next_business_day(date, set())


@then("it is a weekend")
def it_is_weekend(qa):
    qa.check("is a weekend", qa.weekend is True, "weekend " + str(qa.weekend))


@then("it is a weekday")
def it_is_weekday(qa):
    qa.check("is a weekday", qa.weekend is False, "weekend " + str(qa.weekend))


@then(parsers.re(r"^the business day is (?P<expected>\S+)$"))
def business_day_is(qa, expected):
    qa.check("business day == " + expected, qa.business_day == expected, "got " + str(qa.business_day))


# ---------------------------------------------------------------- live holidays


@when(parsers.re(r"^the holidays for (?P<year>\d+) in (?P<country>\S+) are fetched$"))
def holidays_fetched(qa, year, country):
    def go():
        qa.hol = nager.holidays(int(year), country)["body"]
    live(qa, go)


@when(parsers.re(r"^the holidays for (?P<year>\d+) in (?P<country>\S+) are fetched again$"))
def holidays_fetched_again(qa, year, country):
    def go():
        qa.hol2 = nager.holidays(int(year), country)["body"]
    live(qa, go)


@when("the available countries are fetched")
def available_countries_fetched(qa):
    def go():
        qa.countries = nager.available_countries()["body"]
    live(qa, go)


@when(parsers.re(r"^the settlement date after (?P<date>\S+) in (?P<country>\S+) is computed$"))
def settlement_computed(qa, date, country):
    def go():
        lst = nager.holidays(2024, country)["body"]
        qa.hol_set = nager.holiday_set(lst)
        qa.settle_from = date
        qa.settle = nager.next_business_day(date, qa.hol_set)
    live(qa, go)


@then("the holiday list is non-empty")
def holiday_list_non_empty(qa):
    check(qa, "holiday list non-empty", lambda: (isinstance(qa.hol, list) and len(qa.hol) > 0, str(len(qa.hol or [])) + " holidays"))


@then(parsers.parse("the holiday list has {n:d} entries"))
def holiday_list_has_n(qa, n):
    check(qa, "holiday list has " + str(n), lambda: (isinstance(qa.hol, list) and len(qa.hol) == n, str(len(qa.hol or [])) + " holidays"))


@then(parsers.re(r"^the list includes a holiday on (?P<date>\S+)$"))
def list_includes_holiday(qa, date):
    check(qa, "holiday on " + date, lambda: (isinstance(qa.hol, list) and any(h["date"] == date for h in qa.hol), ",".join(h["date"] for h in qa.hol)[:80] if qa.hol else "no list"))


@then("every holiday has a date and a name")
def every_holiday_date_name(qa):
    import re

    def ev():
        bad = [h for h in (qa.hol or []) if not re.match(r"^\d{4}-\d{2}-\d{2}$", h["date"]) or not (h.get("name") and len(h["name"]))]
        return (len(qa.hol or []) > 0 and not bad, "bad " + json.dumps(bad[:2]) if bad else str(len(qa.hol or [])) + " ok")
    check(qa, "every holiday has date + name", ev)


@then("both holiday reads return identical dates")
def both_reads_identical(qa):
    check(qa, "holiday list stable", lambda: (json.dumps([h["date"] for h in (qa.hol or [])]) == json.dumps([h["date"] for h in (qa.hol2 or [])]), "a " + str(len(qa.hol or [])) + " b " + str(len(qa.hol2 or []))))


@then(parsers.re(r"^the available countries include (?P<a>\S+) and (?P<b>\S+)$"))
def countries_include(qa, a, b):
    def ev():
        codes = [c["countryCode"] for c in (qa.countries or [])]
        return (a in codes and b in codes, str(len(codes)) + " countries")
    check(qa, "countries include " + a + "," + b, ev)


@then(parsers.re(r"^the settlement date is (?P<expected>\S+)$"))
def settlement_date_is(qa, expected):
    check(qa, "settlement date == " + expected, lambda: (qa.settle == expected, "from " + str(qa.settle_from) + " -> " + str(qa.settle)))


@then("the settlement date is a business day")
def settlement_is_business_day(qa):
    check(qa, "settlement is a business day", lambda: (nager.is_business_day(qa.settle, qa.hol_set), str(qa.settle) + " weekend? " + str(nager.is_weekend(qa.settle)) + " holiday? " + str(qa.settle in qa.hol_set)))

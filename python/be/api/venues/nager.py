"""Nager.Date's public holiday API (date.nager.at). Mirror of
node/be/api/venues/nager.js. urllib only, no key, read-only.

A past year's holiday list is settled and never changes, so those are asserted by
value and compared across two reads. A transport failure, a 5xx/429, or a non-JSON
body is NagerUnreachable, which grades Blocked: the calendar service being
unreachable is not the calendar being wrong.

``next_business_day`` is a pure function -- the QA-side settlement rule that finds
the first business day after a date, skipping weekends and public holidays. It takes
no network, so the scenarios that exercise it are deterministic.
"""

from __future__ import annotations

import datetime
import json
import os
import urllib.error
import urllib.request

BASE = os.environ.get("NAGER_URL", "https://date.nager.at/api/v3").rstrip("/")
TIMEOUT = 25


class NagerUnreachable(Exception):
    pass


def request(path):
    req = urllib.request.Request(BASE + path, headers={"accept": "application/json"}, method="GET")
    try:
        with urllib.request.urlopen(req, timeout=TIMEOUT) as res:
            status, text = res.status, res.read().decode("utf-8", "replace")
    except urllib.error.HTTPError as err:
        if err.code >= 500 or err.code == 429:
            raise NagerUnreachable(f"GET {path} -- HTTP {err.code}") from err
        status, text = err.code, err.read().decode("utf-8", "replace")
    except (urllib.error.URLError, TimeoutError, OSError) as err:
        raise NagerUnreachable(f"GET {path} -- {err}") from err
    if status >= 500 or status == 429:
        raise NagerUnreachable(f"GET {path} -- HTTP {status}")
    try:
        body = json.loads(text)
    except json.JSONDecodeError:
        body = None
    if body is None or not isinstance(body, (list, dict)):
        raise NagerUnreachable(f"GET {path} -- expected JSON, got " + " ".join(text[:40].split()) + "…")
    return {"httpStatus": status, "body": body}


def holidays(year=2024, country="US"):
    return request(f"/PublicHolidays/{year}/{country}")


def available_countries():
    return request("/AvailableCountries")


# ---- pure business-day arithmetic (UTC, no timezone drift) ----


def add_days(date_str, n):
    d = datetime.date.fromisoformat(date_str) + datetime.timedelta(days=n)
    return d.isoformat()


def is_weekend(date_str):
    # weekday(): Mon=0 .. Sat=5, Sun=6 -- matches node's getUTCDay 0=Sun/6=Sat weekend set.
    return datetime.date.fromisoformat(date_str).weekday() >= 5


def is_business_day(date_str, holiday_set):
    return not is_weekend(date_str) and date_str not in holiday_set


def next_business_day(date_str, holiday_set):
    """The first business day strictly after ``date_str``, skipping weekends and holidays."""
    d = add_days(date_str, 1)
    while not is_business_day(d, holiday_set):
        d = add_days(d, 1)
    return d


def holiday_set(lst):
    """Set of holiday date strings from a Nager holiday list."""
    return {h["date"] for h in (lst or [])}

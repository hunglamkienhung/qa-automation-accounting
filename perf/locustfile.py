"""Locust load test for the mini-books service.

This is the performance counterpart to the functional BDD suite: the same REST
API the journal, report and reversal flows use, driven under concurrency. The
user classes model the real traffic mix -- lots of posting, some report reads, a
few reversals -- and every request validates its response so a wrong status
counts as a failure, not just a slow success.

Run it headless with a pass/fail gate (see perf/run.sh):

    locust -f perf/locustfile.py --headless -u 40 -r 10 -t 30s \
        --host http://127.0.0.1:8170

The `quitting` hook fails the run (non-zero exit) if the error ratio or the p95
latency crosses the thresholds below, so it can gate a pipeline.
"""

from __future__ import annotations

import os
import random

from locust import HttpUser, between, events, task

MAX_FAIL_RATIO = float(os.environ.get("PERF_MAX_FAIL_RATIO", "0.01"))   # 1%
MAX_P95_MS = float(os.environ.get("PERF_MAX_P95_MS", "750"))

ADMIN_TOKEN = os.environ.get("MINI_BOOKS_ADMIN_TOKEN", "admin-token")
BIZ_DAY = "2024-01-03"   # a weekday
# Balanced Dr/Cr pairs a small business books.
PAIRS = [(1, 9), (3, 9), (1, 10), (11, 1), (12, 1), (13, 1), (4, 5), (5, 1), (2, 6), (1, 7)]


def _entry(dr, cr, amount):
    return {"entry_date": BIZ_DAY, "lines": [{"account_id": dr, "side": "debit", "amount_cents": amount}, {"account_id": cr, "side": "credit", "amount_cents": amount}]}


def _post(client, path, name, token=None, json=None, expect=(200, 201)):
    headers = {"authorization": "Bearer " + token} if token else {}
    with client.post(path, json=json, headers=headers, name=name, catch_response=True) as r:
        if r.status_code in expect:
            r.success()
        else:
            r.failure(f"{r.status_code} {r.text[:80]}")
        return r


def _get(client, path, name, token=None):
    headers = {"authorization": "Bearer " + token} if token else {}
    with client.get(path, headers=headers, name=name, catch_response=True) as r:
        if r.status_code == 200:
            r.success()
        else:
            r.failure(f"{r.status_code} {r.text[:80]}")
        return r


def _accountant(client):
    u = _post(client, "/users", "POST /users", json={"name": "Load"}, expect=(201,))
    return u.json()["token"] if u.status_code == 201 else None


class Poster(HttpUser):
    """Registers an accountant and posts balanced journal entries."""

    weight = 5
    wait_time = between(0.1, 0.5)

    @task
    def post(self):
        token = _accountant(self.client)
        if not token:
            return
        dr, cr = random.choice(PAIRS)
        _post(self.client, "/journal-entries", "POST /journal-entries", token=token, json=_entry(dr, cr, random.randint(1, 500000)), expect=(201,))


class Reporter(HttpUser):
    """Reads the financial reports."""

    weight = 2
    wait_time = between(0.2, 0.8)

    @task
    def reports(self):
        token = _accountant(self.client)
        if not token:
            return
        _get(self.client, "/reports/trial-balance", "GET /reports/trial-balance", token=token)
        _get(self.client, "/reports/balance-sheet", "GET /reports/balance-sheet", token=token)


class Reverser(HttpUser):
    """Posts an entry, then the admin reverses it."""

    weight = 1
    wait_time = between(0.3, 1.0)

    @task
    def reverse(self):
        token = _accountant(self.client)
        if not token:
            return
        dr, cr = random.choice(PAIRS)
        e = _post(self.client, "/journal-entries", "POST /journal-entries", token=token, json=_entry(dr, cr, random.randint(1, 100000)), expect=(201,))
        if e.status_code != 201:
            return
        _post(self.client, f"/journal-entries/{e.json()['id']}/reverse", "POST /journal-entries/[id]/reverse", token=ADMIN_TOKEN, expect=(201,))


@events.quitting.add_listener
def _gate(environment, **_kw):
    stats = environment.stats.total
    p95 = stats.get_response_time_percentile(0.95)
    fail_ratio = stats.fail_ratio
    print(f"\nperf gate: requests={stats.num_requests} fails={stats.num_failures} "
          f"fail_ratio={fail_ratio:.4f} p95={p95}ms rps={stats.total_rps:.1f}")
    reasons = []
    if stats.num_requests == 0:
        reasons.append("no requests were made")
    if fail_ratio > MAX_FAIL_RATIO:
        reasons.append(f"fail ratio {fail_ratio:.4f} > {MAX_FAIL_RATIO}")
    if p95 and p95 > MAX_P95_MS:
        reasons.append(f"p95 {p95}ms > {MAX_P95_MS}ms")
    if reasons:
        print("perf gate FAILED: " + "; ".join(reasons))
        environment.process_exit_code = 1
    else:
        print("perf gate PASSED")
        environment.process_exit_code = 0

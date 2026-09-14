#!/usr/bin/env bash
# Load-test mini-books with Locust, headless, with a pass/fail gate.
#
#   bash perf/run.sh [users] [spawn-rate] [duration]
#
# Seeds a fresh mini-books, then drives the journal/report/reversal API under
# concurrency. The locustfile's `quitting` hook exits non-zero if the error
# ratio or p95 latency crosses PERF_MAX_FAIL_RATIO / PERF_MAX_P95_MS, so this
# doubles as a CI performance gate.
set -euo pipefail
USERS="${1:-40}"
RATE="${2:-10}"
DUR="${3:-30s}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
export MINI_BOOKS_DB="${MINI_BOOKS_DB:-/tmp/mini-books-perf/mini-books.db}"
export MINI_BOOKS_PORT="${MINI_BOOKS_PORT:-8170}"
HOST="http://127.0.0.1:${MINI_BOOKS_PORT}"

( cd services/mini-books && bash serve.sh up )

python -m pip install -q -r perf/requirements.txt
locust -f perf/locustfile.py --headless -u "$USERS" -r "$RATE" -t "$DUR" --host "$HOST" --only-summary

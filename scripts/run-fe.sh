#!/usr/bin/env bash
# The mini-books app pages (chart of accounts, an account, an entry, and the
# trial-balance and balance-sheet reports), one stack, with a chromium browser.
# Blocks (never fails) when a screen is unavailable.
set -euo pipefail
STACK="${1:-node}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
export MINI_BOOKS_DB="${MINI_BOOKS_DB:-/tmp/mini-books/mini-books.db}"
( cd services/mini-books && bash serve.sh up )
if [ "$STACK" = node ]; then
  ( cd node && npm install --no-audit --no-fund )
  ( cd node && npx playwright install --with-deps chromium || npx playwright install chromium )
  ( cd node && QA_DOMAIN_ROOT=.. ./node_modules/.bin/cucumber-js --tags "@fe" )
  ( cd node && QA_DOMAIN_ROOT=.. npx qa-report )
else
  python -m venv .venv-ci && . .venv-ci/bin/activate
  ( cd python && pip install -q -r requirements.txt )
  python -m playwright install --with-deps chromium || python -m playwright install chromium
  ( cd python && QA_DOMAIN_ROOT=.. python -m pytest -m "fe" -q ) || true
  ( cd python && QA_DOMAIN_ROOT=.. qa-report )
fi

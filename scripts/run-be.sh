#!/usr/bin/env bash
# Seed a fresh mini-books, then run the accounting BE tiers (DB + journal +
# reports + integrity + security + live Nager.Date) for one stack. No browser.
set -euo pipefail
STACK="${1:-node}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
export MINI_BOOKS_DB="${MINI_BOOKS_DB:-/tmp/mini-books/mini-books.db}"
( cd services/mini-books && bash serve.sh up )
if [ "$STACK" = node ]; then
  ( cd node && npm install --no-audit --no-fund )
  ( cd node && QA_DOMAIN_ROOT=.. ./node_modules/.bin/cucumber-js --tags "@be" )
  ( cd node && QA_DOMAIN_ROOT=.. npx qa-report )
else
  python -m venv .venv-ci && . .venv-ci/bin/activate
  ( cd python && pip install -q -r requirements.txt )
  ( cd python && QA_DOMAIN_ROOT=.. python -m pytest -m "be" -q ) || true
  ( cd python && QA_DOMAIN_ROOT=.. qa-report )
fi

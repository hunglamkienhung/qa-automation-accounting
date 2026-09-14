# qa-automation-accounting

![Pytest-BDD](https://img.shields.io/badge/Pytest--BDD-tests-0A9EDC?logo=pytest&logoColor=white)
![Cucumber](https://img.shields.io/badge/Cucumber-BDD-23D96C?logo=cucumber&logoColor=white)
![Playwright](https://img.shields.io/badge/Playwright-E2E-2EAD33?logo=playwright&logoColor=white)
![SQLite](https://img.shields.io/badge/SQLite-store-003B57?logo=sqlite&logoColor=white)
![Python](https://img.shields.io/badge/Python-3.12-3776AB?logo=python&logoColor=white)
![Node](https://img.shields.io/badge/Node-24-5FA04E?logo=nodedotjs&logoColor=white)
[![CI](https://github.com/hunglamkienhung/qa-automation-accounting/actions/workflows/ci.yml/badge.svg)](https://github.com/hunglamkienhung/qa-automation-accounting/actions/workflows/ci.yml)

QA automation for a **double-entry accounting** domain, built as a working
system rather than a slideshow. One set of books — a chart of accounts, journal
entries, and the three financial reports — held to the laws of bookkeeping:
every entry balances, so the accounting equation holds and the trial balance's
debits equal its credits at all times. It is tested at **every layer it has**
(database, API, and screen) by **two independent stacks** (Node with Cucumber,
Python with pytest-bdd) that read **one** shared set of Gherkin features and must
return the **same verdict for every case**.

Nothing here needs an account, a key, or a paid service. Clone it and it runs.

[Tiếng Việt](README.vi.md) · [Grading](docs/GRADING.md) ·
[Gherkin](docs/GHERKIN.md) · [Queue format](docs/QUEUE-FORMAT.md)

## The two systems under test

| System | Access | What it is |
|---|---|---|
| **mini-books** | read + write, real DB | A small double-entry accounting backend in `services/mini-books`: one SQLite file, Node standard library only, a REST API for the chart of accounts, journal entries, reversals and the trial balance, balance sheet and income statement, and small labelled HTML pages for Playwright. |
| **date.nager.at** | read-only, live | A live, keyless public-holiday API. A past year's holiday list drives a business-day posting/settlement date; nobody here can tune it to pass. |

**511 cases**, each with an immutable ID, run in **both** stacks and reconciled
case-by-case. Every layer the service has is tested at that layer:

| Layer | Target | Cases | Where |
|---|---|---|---|
| DB | mini-books SQLite, opened directly | 90 | `be/db` |
| API | journal entries — balanced debits and credits, at least two lines, business-day dates, active accounts, one currency, idempotency | 124 | `be/api` |
| API | financial reports — trial balance, balance sheet, income statement, balances by type | 117 | `be/api` |
| API | ledger-wide integrity — the accounting equation, reversals, gapless numbering under concurrency | 46 | `be/api` |
| API | authorization boundaries (security) | 15 | `be/api` |
| API | Nager.Date + the business-day settlement built on it | 82 | `be/api` |
| FE | mini-books HTML pages (Playwright) | 37 | `fe/ui` |
| | **Total** | **511** | |

## The laws it enforces

`mini-books` is where the **write** paths live, and it is deliberately exact.

- An account belongs to one of the **five types** (asset, liability, equity,
  revenue, expense), which fixes its **normal balance** — asset and expense
  accounts carry a debit balance, liability, equity and revenue accounts a credit
  balance.
- A **journal entry** is a set of debit and credit lines whose **debits equal its
  credits**, in whole cents, dated on a **business day** (weekends are refused),
  against **active accounts** that share a **currency**, and it is **idempotent by
  key**. The journal tier books the everyday transactions of a small business — a
  cash sale, a credit sale, paying rent, buying inventory on credit, taking a
  loan, an owner's investment — and rejects the entries a bookkeeper must never
  accept.
- Because every entry balances, the **reports** obey accounting at all times: the
  trial balance's debits equal its credits, the **balance sheet balances**
  (Assets = Liabilities + Equity + Net income), **net income = revenue − expenses**,
  and the **accounting equation** holds. The reports tier checks these invariants
  after every kind of posting, and checks each report figure moves by exactly the
  amount a transaction should move it.
- A **reversal** (admin only) writes the original lines with their sides swapped
  and restores the figures it undoes; it cannot be applied twice or to a reversal.

## The invariant worth the repo, and concurrency

Double entry means the books stay in balance after every posting — and they stay
consistent **under concurrency**. Each entry is numbered inside one
`BEGIN IMMEDIATE` transaction as `MAX(entry_no) + 1`, so when many entries post at
the same instant the journal is numbered by a **gapless, duplicate-free
sequence** (a real accounting concern — no missing or repeated journal numbers),
and a repeated post with one idempotency key posts exactly once. The integrity
tier proves both with real concurrent bursts — `Promise.all` in Node, a thread
pool in Python.

## The two ideas worth a minute

**One Gherkin set, two stacks, one verdict.** `features/*.feature` are shared.
`node/` runs them with Cucumber; `python/` runs the same files with pytest-bdd.
A per-case disagreement is itself a finding, and the build fails on it.

**Failed > Blocked > Passed, and an outage is never a failure.** A case is
Failed only when an observed proposition is wrong. When the live source
(Nager.Date, a down service) cannot be reached, the case is **Blocked**, never
Failed. The CI gate checks the *shape* of a run against
`fixtures/expected-results.json`. See [docs/GRADING.md](docs/GRADING.md).

## Run in 30 seconds

```bash
# the shared grading core, both stacks
cd core/node && node --test "selftest/*.test.js"
cd ../python && pip install -e . && python -m pytest selftest -q
```

## Run the whole suite

Each step below is exactly what CI runs (`scripts/*.sh`), so it works by hand too.

```bash
# backend, one stack, no browser (seed mini-books, then DB + journal + reports + integrity + security + Nager.Date)
bash scripts/run-be.sh node       # or: python

# the app pages (installs a chromium browser)
bash scripts/run-fe.sh node       # or: python

# the whole suite, then verify the run's shape against the baseline
bash scripts/gate.sh node
```

By hand, one tier at a time:

```bash
( cd services/mini-books && bash serve.sh up )    # fresh seeded service
cd node && QA_DOMAIN_ROOT=.. npx cucumber-js --tags "@be and @reports"
```

Prerequisites: Node ≥ 22.13 (for `node:sqlite`) and Python ≥ 3.11. The FE
scripts install their own browser. A devcontainer with all of it is in
[.devcontainer/](.devcontainer/devcontainer.json). A Locust load test is in
[perf/](perf/README.md).

## Layout

```
core/            one grading/queue/report/bugflow core, vendored into this repo
services/
  mini-books/    SQLite + REST + HTML — the double-entry books under test
features/        one Gherkin set, shared by both stacks
fixtures/        testcases.json (IDs) · expected-results.json (shape)
node/  python/   the two stacks: be/{db,api} fe/ui
testcases/       catalogue generated from the features (never drifts)
perf/            a Locust load test with a pass/fail gate
scripts/         the exact commands CI runs; reproducible by hand
docs/            grading rules, Gherkin conventions, queue format
.github/workflows/ci.yml
```

## Notes

- The balance, report-figure and settlement assertions do not read the service's
  own number back — they **recompute** it and compare, so a wiring or rounding bug
  surfaces as a mismatch. Because seeded accounts accumulate across scenarios,
  balance and figure checks are on **deltas** (note, post, check the change),
  while the accounting invariants (balanced, equation holds) are absolute.
- Double entry is checked from three sides: the API tier posts entries and reads
  the reports; the DB tier reads the `lines` and the grand totals directly; the FE
  tier reads the chart of accounts and the report pages and compares them with the
  same rows.
- The catalogue is generated from the feature files by `testcases/build.js`, so it
  can never drift from what runs — CI checks it with `--check`.

## Honest scope

The live-source tier (Nager.Date) depends on a third party that can be slow or
unreachable; those cases grade **Blocked**, not Failed, when that happens, and the
business-day rule built on it is a pure function checked deterministically with no
network. The self-written mini-books service is fully deterministic and is where
double entry, the five account types, the financial reports, the no-gap numbering
guarantee and the authorization boundaries are exercised.

-- mini-books: a small but real double-entry accounting backend over one SQLite
-- file. The tables are the object under test; every test stack opens this same
-- file and asserts on its rows, and the REST layer (the chart of accounts,
-- journal entries, reversals and the financial reports) reads and writes it.
--
-- This is proper double-entry bookkeeping, not a wallet. Accounts are a chart of
-- accounts classified into the five types (asset, liability, equity, revenue,
-- expense). A journal entry is a set of debit and credit lines whose debits
-- equal its credits, in integer cents. Because every entry balances, the ledger
-- obeys the accounting equation at all times -- Assets = Liabilities + Equity +
-- Revenue - Expenses -- and the trial balance's debit and credit totals are
-- equal. Entries are numbered by a gapless sequence, so a bug in concurrency
-- shows up as a duplicate or a gap, not a silent hole in the books.

PRAGMA journal_mode = WAL;
PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS users (
  id         INTEGER PRIMARY KEY,
  name       TEXT    NOT NULL,
  token      TEXT    UNIQUE,
  created_at INTEGER NOT NULL
);

-- The chart of accounts. `type` decides an account's normal balance: asset and
-- expense accounts carry a debit balance, liability, equity and revenue accounts
-- carry a credit balance.
CREATE TABLE IF NOT EXISTS accounts (
  id         INTEGER PRIMARY KEY,
  code       TEXT    NOT NULL UNIQUE,
  name       TEXT    NOT NULL,
  type       TEXT    NOT NULL CHECK (type IN ('asset', 'liability', 'equity', 'revenue', 'expense')),
  currency   TEXT    NOT NULL,
  active     INTEGER NOT NULL DEFAULT 1 CHECK (active IN (0, 1)),
  created_at INTEGER NOT NULL
);

-- A journal entry: a dated, memo'd set of balanced lines. `entry_no` is a gapless
-- sequence assigned when the entry posts. A reversal points back at the entry it
-- undoes.
CREATE TABLE IF NOT EXISTS journal_entries (
  id              INTEGER PRIMARY KEY,
  entry_no        INTEGER NOT NULL UNIQUE,
  entry_date      TEXT    NOT NULL,
  memo            TEXT,
  status          TEXT    NOT NULL DEFAULT 'posted' CHECK (status IN ('posted', 'reversed')),
  reverses_id     INTEGER REFERENCES journal_entries(id),
  idempotency_key TEXT    UNIQUE,
  created_at      INTEGER NOT NULL
);

-- One line of an entry: a debit or a credit of a positive amount against an
-- account. The debit lines and the credit lines of an entry sum to the same
-- amount (enforced by the service; asserted from these rows by the DB tier).
CREATE TABLE IF NOT EXISTS lines (
  id           INTEGER PRIMARY KEY,
  entry_id     INTEGER NOT NULL REFERENCES journal_entries(id),
  account_id   INTEGER NOT NULL REFERENCES accounts(id),
  side         TEXT    NOT NULL CHECK (side IN ('debit', 'credit')),
  amount_cents INTEGER NOT NULL CHECK (amount_cents > 0),
  created_at   INTEGER NOT NULL
);
CREATE INDEX IF NOT EXISTS lines_entry ON lines(entry_id);
CREATE INDEX IF NOT EXISTS lines_account ON lines(account_id);

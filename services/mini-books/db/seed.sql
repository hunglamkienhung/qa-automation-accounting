-- Deterministic seed. Idempotent: INSERT OR IGNORE by primary key. Money in
-- cents. A standard small-business chart of accounts across the five types, one
-- EUR account so a cross-currency entry can be refused, and one archived account
-- so posting to an inactive account can be refused. The books open with one
-- balanced entry -- the owner investing capital -- so the accounting equation
-- holds and the trial balance is balanced from the very first read.

INSERT OR IGNORE INTO users (id, name, token, created_at) VALUES
  (1, 'Iris Bookman',  'usr_seed_book', 1700000000),
  (2, 'Cole Ledford',  'usr_seed_aux',  1700000000);

-- The chart of accounts. Codes follow the usual 1000s=assets, 2000s=liabilities,
-- 3000s=equity, 4000s=revenue, 5000s=expenses convention.
INSERT OR IGNORE INTO accounts (id, code, name, type, currency, active, created_at) VALUES
  (1,  '1000', 'Cash',                 'asset',     'USD', 1, 1700000000),
  (2,  '1100', 'Bank',                 'asset',     'USD', 1, 1700000000),
  (3,  '1200', 'Accounts Receivable',  'asset',     'USD', 1, 1700000000),
  (4,  '1300', 'Inventory',            'asset',     'USD', 1, 1700000000),
  (5,  '2000', 'Accounts Payable',     'liability', 'USD', 1, 1700000000),
  (6,  '2100', 'Loan Payable',         'liability', 'USD', 1, 1700000000),
  (7,  '3000', 'Owner Capital',        'equity',    'USD', 1, 1700000000),
  (8,  '3100', 'Retained Earnings',    'equity',    'USD', 1, 1700000000),
  (9,  '4000', 'Sales Revenue',        'revenue',   'USD', 1, 1700000000),
  (10, '4100', 'Service Revenue',      'revenue',   'USD', 1, 1700000000),
  (11, '5000', 'Rent Expense',         'expense',   'USD', 1, 1700000000),
  (12, '5100', 'Salaries Expense',     'expense',   'USD', 1, 1700000000),
  (13, '5200', 'Supplies Expense',     'expense',   'USD', 1, 1700000000),
  (14, '5300', 'Utilities Expense',    'expense',   'USD', 1, 1700000000),
  (15, '1900', 'Cash (EUR)',           'asset',     'EUR', 1, 1700000000),   -- other currency, for mismatch checks
  (16, '1800', 'Old Petty Cash',       'asset',     'USD', 0, 1700000000);   -- archived on purpose

-- Opening entry #1: the owner invests $100,000 in cash. Debit Cash, credit Owner
-- Capital -- balanced, so Assets = Equity from the start.
INSERT OR IGNORE INTO journal_entries (id, entry_no, entry_date, memo, status, reverses_id, idempotency_key, created_at) VALUES
  (1, 1, '2024-01-02', 'Owner investment of capital', 'posted', NULL, 'seed-open-1', 1700000000);
INSERT OR IGNORE INTO lines (id, entry_id, account_id, side, amount_cents, created_at) VALUES
  (1, 1, 1, 'debit',  10000000, 1700000000),   -- Cash          Dr 100,000.00
  (2, 1, 7, 'credit', 10000000, 1700000000);   -- Owner Capital Cr 100,000.00

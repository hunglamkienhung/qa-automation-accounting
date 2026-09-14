@module:01-mini-books-db @be @db @books
Feature: The mini-books store, read directly

  Both stacks open the SQLite file the mini-books service writes and assert on
  its rows. The service is driven through its HTTP API to create state -- a cash
  sale, rent paid, an owner investment, a reversal -- and the accounts, journal
  entries and lines are then read straight from the file.

  Double entry is the invariant this tier reads from the rows: every entry's
  debit lines equal its credit lines, so the grand total of every debit equals
  the grand total of every credit; an account's balance is its debits less its
  credits interpreted by its type; and a reversal writes the original lines with
  their sides swapped. Because seeded accounts accumulate across scenarios,
  balance checks are on DELTAS -- note the balance, post, check what changed.

  Background:
    Given the store is open and the service is reachable

  # ---------------------------------------------------------------- schema (throwaway db)

  @case:1 @priority:high
  Scenario: The store has the documented tables
    Then the store has tables users, accounts, journal_entries, lines

  @case:2 @priority:high
  Scenario: An account type is one of the five
    Given a throwaway database with the schema applied
    Then inserting an account with type "income" fails a CHECK

  @case:3 @priority:high
  Scenario: A line references a real entry and account
    Given a throwaway database with the schema applied
    Then inserting a line for a missing entry fails a FOREIGN KEY
    And inserting a line for a missing account fails a FOREIGN KEY

  @case:4 @priority:high
  Scenario: A line side is a debit or a credit
    Given a throwaway database with the schema applied
    Then inserting a line with side "dr" fails a CHECK

  @case:5 @priority:high
  Scenario: A line amount is positive
    Given a throwaway database with the schema applied
    Then inserting a line with a zero amount fails a CHECK

  @case:6 @priority:high
  Scenario: An entry status is posted or reversed
    Given a throwaway database with the schema applied
    Then inserting an entry with status "draft" fails a CHECK

  @case:7 @priority:medium
  Scenario: An account active flag is a boolean
    Given a throwaway database with the schema applied
    Then inserting an account with active flag 2 fails a CHECK

  @case:8 @priority:high
  Scenario: An entry number is unique
    Given a throwaway database with the schema applied
    Then inserting two entries with the same entry number fails on the second

  @case:9 @priority:medium
  Scenario: An account code is unique
    Given a throwaway database with the schema applied
    Then inserting two accounts with the same code fails on the second

  @case:10 @priority:medium
  Scenario: An entry idempotency key is unique
    Given a throwaway database with the schema applied
    Then inserting two entries with the same idempotency key fails on the second

  @case:11 @priority:medium
  Scenario: Seeding twice leaves the same rows
    Given a throwaway database with the schema and seed applied
    Then applying the seed again changes no row counts

  # ---------------------------------------------------------------- the seeded chart of accounts

  @case:12 @priority:high
  Scenario: The seeded books already balance
    Then the whole ledger is balanced

  @case:13 @priority:high
  Scenario: The chart of accounts covers all five types
    Then the chart of accounts has an account of every type

  @case:14 @priority:medium
  Scenario: The opening entry is a balanced pair
    Then entry number 1 has exactly two lines
    And entry number 1's debit and credit lines are equal

  # ---------------------------------------------------------------- posting writes balanced lines

  @case:15 @priority:high
  Scenario: A cash sale writes a balanced two-line entry
    Given an accountant
    And a cash sale of 50000
    Then the entry's debit and credit lines are equal
    And the entry has exactly two lines

  @case:16 @priority:high
  Scenario: The cash sale debits Cash and credits Sales Revenue
    Given an accountant
    And a cash sale of 25000
    Then the debit line hits account 1 and the credit line hits account 9

  @case:17 @priority:high
  Scenario: Paying rent debits Rent Expense and credits Cash
    Given an accountant
    And rent paid of 12000
    Then the debit line hits account 11 and the credit line hits account 1

  @case:18 @priority:high
  Scenario: A cash sale raises Cash and Sales by the amount
    Given an accountant
    And the balance of account 1 is noted
    And the balance of account 9 is noted
    And a cash sale of 40000
    Then account 1 balance rose by 40000
    And account 9 balance rose by 40000

  @case:19 @priority:high
  Scenario: Paying rent lowers Cash and raises Rent Expense
    Given an accountant
    And the balance of account 1 is noted
    And the balance of account 11 is noted
    And rent paid of 15000
    Then account 1 balance fell by 15000
    And account 11 balance rose by 15000

  @case:20 @priority:high
  Scenario: An owner investment raises Cash and Owner Capital
    Given an accountant
    And the balance of account 1 is noted
    And the balance of account 7 is noted
    And an owner investment of 100000
    Then account 1 balance rose by 100000
    And account 7 balance rose by 100000

  @case:21 @priority:high
  Scenario: Posting keeps the whole ledger balanced
    Given an accountant
    And a cash sale of 50000
    Then the whole ledger is balanced

  @case:22 @priority:high
  Scenario: An entry is given the next number
    Given an accountant
    And a cash sale of 10000
    Then the entry number is at least 2

  @case:23 @priority:high
  Scenario: Entry numbers are gapless
    Given an accountant
    And a cash sale of 10000
    Then the entry numbers run without a gap

  @case:24 @priority:medium
  Scenario: A repeated post with one key writes one entry
    Given an accountant
    And a cash sale of 20000 with key "db-idem-1"
    And the same cash sale is retried with key "db-idem-1"
    Then only one entry carries that idempotency key

  # ---------------------------------------------------------------- reversals

  @case:25 @priority:high
  Scenario: A reversal writes the original lines with their sides swapped
    Given an accountant
    And a cash sale of 30000
    And the entry is reversed by the admin
    Then the reversal's lines are the original's with sides swapped
    And the original entry row is reversed

  @case:26 @priority:high
  Scenario: A reversal keeps the whole ledger balanced
    Given an accountant
    And a cash sale of 30000
    And the entry is reversed by the admin
    Then the whole ledger is balanced

  # ---------------------------------------------------------------- integrity

  @case:27 @priority:medium
  Scenario: No line references a missing entry or account
    Then no lines row references an entry missing from journal_entries
    And no lines row references an account missing from accounts

  @case:28 @priority:high
  Scenario: Every entry has at least two lines and balances
    Then every entry in the store has at least two lines
    And every entry's debits equal its credits

  # ---------------------------------------------------------------- parameterised balanced entries

  Scenario Outline: A balanced entry Dr <dr> Cr <cr> for <amount> writes two balanced lines
    Given an accountant
    And a balanced entry debiting account <dr> and crediting account <cr> for <amount>
    Then the entry's debit and credit lines are equal
    And the entry has exactly two lines
    And the whole ledger is balanced

    @case:29
    Examples:
      | dr | cr | amount |
      | 1 | 9 | 10000 |
    @case:30
    Examples:
      | dr | cr | amount |
      | 2 | 10 | 25000 |
    @case:31
    Examples:
      | dr | cr | amount |
      | 3 | 9 | 33333 |
    @case:32
    Examples:
      | dr | cr | amount |
      | 11 | 1 | 5000 |
    @case:33
    Examples:
      | dr | cr | amount |
      | 12 | 2 | 80000 |
    @case:34
    Examples:
      | dr | cr | amount |
      | 4 | 5 | 45000 |
    @case:35
    Examples:
      | dr | cr | amount |
      | 1 | 6 | 200000 |
    @case:36
    Examples:
      | dr | cr | amount |
      | 13 | 5 | 7500 |
    @case:37
    Examples:
      | dr | cr | amount |
      | 1 | 7 | 500000 |
    @case:38
    Examples:
      | dr | cr | amount |
      | 14 | 1 | 3200 |
    @case:39
    Examples:
      | dr | cr | amount |
      | 1 | 10 | 60000 |
    @case:40
    Examples:
      | dr | cr | amount |
      | 3 | 10 | 90000 |

  # ---------------------------------------------------------------- normal-balance signs

  Scenario Outline: Debiting a <type> account (<dr>) and crediting Cash moves it by its normal sign
    Given an accountant
    And the balance of account <dr> is noted
    And a balanced entry debiting account <dr> and crediting account 1 for <amount>
    Then account <dr> balance rose by <delta>

    @case:41
    Examples:
      | type | dr | amount | delta |
      | asset (Bank) | 2 | 10000 | 10000 |
    @case:42
    Examples:
      | type | dr | amount | delta |
      | expense (Rent) | 11 | 8000 | 8000 |
    @case:43
    Examples:
      | type | dr | amount | delta |
      | asset (Inventory) | 4 | 12000 | 12000 |
    @case:44
    Examples:
      | type | dr | amount | delta |
      | expense (Salaries) | 12 | 30000 | 30000 |

  Scenario Outline: Crediting a <type> account (<cr>) and debiting Cash moves it by its normal sign
    Given an accountant
    And the balance of account <cr> is noted
    And a balanced entry debiting account 1 and crediting account <cr> for <amount>
    Then account <cr> balance rose by <delta>

    @case:45
    Examples:
      | type | cr | amount | delta |
      | revenue (Sales) | 9 | 15000 | 15000 |
    @case:46
    Examples:
      | type | cr | amount | delta |
      | liability (Loan) | 6 | 50000 | 50000 |
    @case:47
    Examples:
      | type | cr | amount | delta |
      | equity (Owner) | 7 | 70000 | 70000 |
    @case:48
    Examples:
      | type | cr | amount | delta |
      | revenue (Service) | 10 | 9000 | 9000 |

  Scenario Outline: More balanced entry Dr <dr> Cr <cr> for <amount> is a balanced pair
    Given an accountant
    And a balanced entry debiting account <dr> and crediting account <cr> for <amount>
    Then the entry's debit and credit lines are equal
    And the entry has exactly two lines
    And the whole ledger is balanced

    @case:398
    Examples:
      | dr | cr | amount |
      | 2 | 1 | 100 |
    @case:399
    Examples:
      | dr | cr | amount |
      | 3 | 1 | 999 |
    @case:400
    Examples:
      | dr | cr | amount |
      | 4 | 1 | 2500 |
    @case:401
    Examples:
      | dr | cr | amount |
      | 11 | 1 | 7777 |
    @case:402
    Examples:
      | dr | cr | amount |
      | 12 | 1 | 12345 |
    @case:403
    Examples:
      | dr | cr | amount |
      | 13 | 1 | 33333 |
    @case:404
    Examples:
      | dr | cr | amount |
      | 14 | 1 | 50000 |
    @case:405
    Examples:
      | dr | cr | amount |
      | 1 | 2 | 64000 |
    @case:406
    Examples:
      | dr | cr | amount |
      | 3 | 2 | 90909 |
    @case:407
    Examples:
      | dr | cr | amount |
      | 4 | 2 | 123456 |
    @case:408
    Examples:
      | dr | cr | amount |
      | 11 | 2 | 200000 |
    @case:409
    Examples:
      | dr | cr | amount |
      | 12 | 2 | 275000 |
    @case:410
    Examples:
      | dr | cr | amount |
      | 13 | 2 | 450000 |
    @case:411
    Examples:
      | dr | cr | amount |
      | 14 | 2 | 7 |
    @case:412
    Examples:
      | dr | cr | amount |
      | 1 | 5 | 64 |
    @case:413
    Examples:
      | dr | cr | amount |
      | 2 | 5 | 8888 |
    @case:414
    Examples:
      | dr | cr | amount |
      | 3 | 5 | 100 |
    @case:415
    Examples:
      | dr | cr | amount |
      | 4 | 5 | 999 |
    @case:416
    Examples:
      | dr | cr | amount |
      | 11 | 5 | 2500 |
    @case:417
    Examples:
      | dr | cr | amount |
      | 12 | 5 | 7777 |
    @case:418
    Examples:
      | dr | cr | amount |
      | 13 | 5 | 12345 |
    @case:419
    Examples:
      | dr | cr | amount |
      | 14 | 5 | 33333 |
    @case:420
    Examples:
      | dr | cr | amount |
      | 1 | 6 | 50000 |
    @case:421
    Examples:
      | dr | cr | amount |
      | 2 | 6 | 64000 |
    @case:422
    Examples:
      | dr | cr | amount |
      | 3 | 6 | 90909 |
    @case:423
    Examples:
      | dr | cr | amount |
      | 4 | 6 | 123456 |
    @case:424
    Examples:
      | dr | cr | amount |
      | 11 | 6 | 200000 |
    @case:425
    Examples:
      | dr | cr | amount |
      | 12 | 6 | 275000 |
    @case:426
    Examples:
      | dr | cr | amount |
      | 13 | 6 | 450000 |
    @case:427
    Examples:
      | dr | cr | amount |
      | 14 | 6 | 7 |
    @case:428
    Examples:
      | dr | cr | amount |
      | 1 | 7 | 64 |
    @case:429
    Examples:
      | dr | cr | amount |
      | 2 | 7 | 8888 |
    @case:430
    Examples:
      | dr | cr | amount |
      | 3 | 7 | 100 |
    @case:431
    Examples:
      | dr | cr | amount |
      | 4 | 7 | 999 |
    @case:432
    Examples:
      | dr | cr | amount |
      | 11 | 7 | 2500 |
    @case:433
    Examples:
      | dr | cr | amount |
      | 12 | 7 | 7777 |
    @case:434
    Examples:
      | dr | cr | amount |
      | 13 | 7 | 12345 |
    @case:435
    Examples:
      | dr | cr | amount |
      | 14 | 7 | 33333 |
    @case:436
    Examples:
      | dr | cr | amount |
      | 1 | 9 | 50000 |
    @case:437
    Examples:
      | dr | cr | amount |
      | 2 | 9 | 64000 |
    @case:438
    Examples:
      | dr | cr | amount |
      | 3 | 9 | 90909 |
    @case:439
    Examples:
      | dr | cr | amount |
      | 4 | 9 | 123456 |

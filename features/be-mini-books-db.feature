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
    @case:512
    Examples:
      | dr | cr | amount |
      | 1 | 2 | 100 |
    @case:513
    Examples:
      | dr | cr | amount |
      | 1 | 3 | 113 |
    @case:514
    Examples:
      | dr | cr | amount |
      | 1 | 4 | 126 |
    @case:515
    Examples:
      | dr | cr | amount |
      | 1 | 5 | 139 |
    @case:516
    Examples:
      | dr | cr | amount |
      | 1 | 6 | 152 |
    @case:517
    Examples:
      | dr | cr | amount |
      | 1 | 7 | 165 |
    @case:518
    Examples:
      | dr | cr | amount |
      | 1 | 8 | 178 |
    @case:519
    Examples:
      | dr | cr | amount |
      | 1 | 9 | 191 |
    @case:520
    Examples:
      | dr | cr | amount |
      | 1 | 10 | 204 |
    @case:521
    Examples:
      | dr | cr | amount |
      | 1 | 11 | 217 |
    @case:522
    Examples:
      | dr | cr | amount |
      | 1 | 12 | 230 |
    @case:523
    Examples:
      | dr | cr | amount |
      | 1 | 13 | 243 |
    @case:524
    Examples:
      | dr | cr | amount |
      | 1 | 14 | 256 |
    @case:525
    Examples:
      | dr | cr | amount |
      | 2 | 1 | 269 |
    @case:526
    Examples:
      | dr | cr | amount |
      | 2 | 3 | 282 |
    @case:527
    Examples:
      | dr | cr | amount |
      | 2 | 4 | 295 |
    @case:528
    Examples:
      | dr | cr | amount |
      | 2 | 5 | 308 |
    @case:529
    Examples:
      | dr | cr | amount |
      | 2 | 6 | 321 |
    @case:530
    Examples:
      | dr | cr | amount |
      | 2 | 7 | 334 |
    @case:531
    Examples:
      | dr | cr | amount |
      | 2 | 8 | 347 |
    @case:532
    Examples:
      | dr | cr | amount |
      | 2 | 9 | 360 |
    @case:533
    Examples:
      | dr | cr | amount |
      | 2 | 10 | 373 |
    @case:534
    Examples:
      | dr | cr | amount |
      | 2 | 11 | 386 |
    @case:535
    Examples:
      | dr | cr | amount |
      | 2 | 12 | 399 |
    @case:536
    Examples:
      | dr | cr | amount |
      | 2 | 13 | 412 |
    @case:537
    Examples:
      | dr | cr | amount |
      | 2 | 14 | 425 |
    @case:538
    Examples:
      | dr | cr | amount |
      | 3 | 1 | 438 |
    @case:539
    Examples:
      | dr | cr | amount |
      | 3 | 2 | 451 |
    @case:540
    Examples:
      | dr | cr | amount |
      | 3 | 4 | 464 |
    @case:541
    Examples:
      | dr | cr | amount |
      | 3 | 5 | 477 |
    @case:542
    Examples:
      | dr | cr | amount |
      | 3 | 6 | 490 |
    @case:543
    Examples:
      | dr | cr | amount |
      | 3 | 7 | 503 |
    @case:544
    Examples:
      | dr | cr | amount |
      | 3 | 8 | 516 |
    @case:545
    Examples:
      | dr | cr | amount |
      | 3 | 9 | 529 |
    @case:546
    Examples:
      | dr | cr | amount |
      | 3 | 10 | 542 |
    @case:547
    Examples:
      | dr | cr | amount |
      | 3 | 11 | 555 |
    @case:548
    Examples:
      | dr | cr | amount |
      | 3 | 12 | 568 |
    @case:549
    Examples:
      | dr | cr | amount |
      | 3 | 13 | 581 |
    @case:550
    Examples:
      | dr | cr | amount |
      | 3 | 14 | 594 |
    @case:551
    Examples:
      | dr | cr | amount |
      | 4 | 1 | 607 |
    @case:552
    Examples:
      | dr | cr | amount |
      | 4 | 2 | 620 |
    @case:553
    Examples:
      | dr | cr | amount |
      | 4 | 3 | 633 |
    @case:554
    Examples:
      | dr | cr | amount |
      | 4 | 5 | 646 |
    @case:555
    Examples:
      | dr | cr | amount |
      | 4 | 6 | 659 |
    @case:556
    Examples:
      | dr | cr | amount |
      | 4 | 7 | 672 |
    @case:557
    Examples:
      | dr | cr | amount |
      | 4 | 8 | 685 |
    @case:558
    Examples:
      | dr | cr | amount |
      | 4 | 9 | 698 |
    @case:559
    Examples:
      | dr | cr | amount |
      | 4 | 10 | 711 |
    @case:560
    Examples:
      | dr | cr | amount |
      | 4 | 11 | 724 |
    @case:561
    Examples:
      | dr | cr | amount |
      | 4 | 12 | 737 |
    @case:562
    Examples:
      | dr | cr | amount |
      | 4 | 13 | 750 |
    @case:563
    Examples:
      | dr | cr | amount |
      | 4 | 14 | 763 |
    @case:564
    Examples:
      | dr | cr | amount |
      | 5 | 1 | 776 |
    @case:565
    Examples:
      | dr | cr | amount |
      | 5 | 2 | 789 |
    @case:566
    Examples:
      | dr | cr | amount |
      | 5 | 3 | 802 |
    @case:567
    Examples:
      | dr | cr | amount |
      | 5 | 4 | 815 |
    @case:568
    Examples:
      | dr | cr | amount |
      | 5 | 6 | 828 |
    @case:569
    Examples:
      | dr | cr | amount |
      | 5 | 7 | 841 |
    @case:570
    Examples:
      | dr | cr | amount |
      | 5 | 8 | 854 |
    @case:571
    Examples:
      | dr | cr | amount |
      | 5 | 9 | 867 |
    @case:572
    Examples:
      | dr | cr | amount |
      | 5 | 10 | 880 |
    @case:573
    Examples:
      | dr | cr | amount |
      | 5 | 11 | 893 |
    @case:574
    Examples:
      | dr | cr | amount |
      | 5 | 12 | 906 |
    @case:575
    Examples:
      | dr | cr | amount |
      | 5 | 13 | 919 |
    @case:576
    Examples:
      | dr | cr | amount |
      | 5 | 14 | 932 |
    @case:577
    Examples:
      | dr | cr | amount |
      | 6 | 1 | 945 |
    @case:578
    Examples:
      | dr | cr | amount |
      | 6 | 2 | 958 |
    @case:579
    Examples:
      | dr | cr | amount |
      | 6 | 3 | 971 |
    @case:580
    Examples:
      | dr | cr | amount |
      | 6 | 4 | 984 |
    @case:581
    Examples:
      | dr | cr | amount |
      | 6 | 5 | 997 |
    @case:582
    Examples:
      | dr | cr | amount |
      | 6 | 7 | 1010 |
    @case:583
    Examples:
      | dr | cr | amount |
      | 6 | 8 | 1023 |
    @case:584
    Examples:
      | dr | cr | amount |
      | 6 | 9 | 1036 |
    @case:585
    Examples:
      | dr | cr | amount |
      | 6 | 10 | 1049 |
    @case:586
    Examples:
      | dr | cr | amount |
      | 6 | 11 | 1062 |
    @case:587
    Examples:
      | dr | cr | amount |
      | 6 | 12 | 1075 |
    @case:588
    Examples:
      | dr | cr | amount |
      | 6 | 13 | 1088 |
    @case:589
    Examples:
      | dr | cr | amount |
      | 6 | 14 | 1101 |
    @case:590
    Examples:
      | dr | cr | amount |
      | 7 | 1 | 1114 |
    @case:591
    Examples:
      | dr | cr | amount |
      | 7 | 2 | 1127 |
    @case:592
    Examples:
      | dr | cr | amount |
      | 7 | 3 | 1140 |
    @case:593
    Examples:
      | dr | cr | amount |
      | 7 | 4 | 1153 |
    @case:594
    Examples:
      | dr | cr | amount |
      | 7 | 5 | 1166 |
    @case:595
    Examples:
      | dr | cr | amount |
      | 7 | 6 | 1179 |
    @case:596
    Examples:
      | dr | cr | amount |
      | 7 | 8 | 1192 |
    @case:597
    Examples:
      | dr | cr | amount |
      | 7 | 9 | 1205 |
    @case:598
    Examples:
      | dr | cr | amount |
      | 7 | 10 | 1218 |
    @case:599
    Examples:
      | dr | cr | amount |
      | 7 | 11 | 1231 |
    @case:600
    Examples:
      | dr | cr | amount |
      | 7 | 12 | 1244 |
    @case:601
    Examples:
      | dr | cr | amount |
      | 7 | 13 | 1257 |
    @case:602
    Examples:
      | dr | cr | amount |
      | 7 | 14 | 1270 |
    @case:603
    Examples:
      | dr | cr | amount |
      | 8 | 1 | 1283 |
    @case:604
    Examples:
      | dr | cr | amount |
      | 8 | 2 | 1296 |
    @case:605
    Examples:
      | dr | cr | amount |
      | 8 | 3 | 1309 |
    @case:606
    Examples:
      | dr | cr | amount |
      | 8 | 4 | 1322 |
    @case:607
    Examples:
      | dr | cr | amount |
      | 8 | 5 | 1335 |
    @case:608
    Examples:
      | dr | cr | amount |
      | 8 | 6 | 1348 |
    @case:609
    Examples:
      | dr | cr | amount |
      | 8 | 7 | 1361 |
    @case:610
    Examples:
      | dr | cr | amount |
      | 8 | 9 | 1374 |
    @case:611
    Examples:
      | dr | cr | amount |
      | 8 | 10 | 1387 |


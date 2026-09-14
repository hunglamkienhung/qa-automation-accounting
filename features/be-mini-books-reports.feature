@module:03-mini-books-reports @be @api @books @reports
Feature: The financial reports

  Because every entry balances, the reports built from the ledger obey the laws
  of accounting at all times: the trial balance's debits equal its credits, the
  balance sheet balances (Assets = Liabilities + Equity + Net income), net income
  is revenue less expenses, and the accounting equation holds. These invariants
  are checked after each kind of posting, and the report figures are checked to
  move by exactly the amount a transaction should move them.

  Background:
    Given the store is open and the service is reachable
    And an accountant

  # ---------------------------------------------------------------- the standing invariants

  @case:101 @priority:high
  Scenario: The trial balance's debits equal its credits
    When the trial balance is fetched
    Then the trial balance is balanced

  @case:102 @priority:high
  Scenario: The balance sheet balances
    When the balance sheet is fetched
    Then the balance sheet balances

  @case:103 @priority:high
  Scenario: Net income is revenue less expenses
    When the income statement is fetched
    Then net income equals revenue minus expenses

  @case:104 @priority:high
  Scenario: The accounting equation holds
    When the accounting equation is fetched
    Then the accounting equation holds

  @case:105 @priority:high
  Scenario: The trial balance stays balanced after a cash sale
    When the accountant posts Dr account 1 Cr account 9 for 50000
    And the trial balance is fetched
    Then the trial balance is balanced

  @case:106 @priority:high
  Scenario: The balance sheet stays balanced after a purchase on credit
    When the accountant posts Dr account 4 Cr account 5 for 250000
    And the balance sheet is fetched
    Then the balance sheet balances

  @case:107 @priority:high
  Scenario: The equation holds after paying an expense
    When the accountant posts Dr account 11 Cr account 1 for 18000
    And the accounting equation is fetched
    Then the accounting equation holds

  @case:108 @priority:medium
  Scenario: The trial balance lists a debit balance for an asset
    When the trial balance is fetched
    Then the trial balance shows account 1 with a debit balance

  @case:109 @priority:medium
  Scenario: The trial balance lists a credit balance for equity
    When the trial balance is fetched
    Then the trial balance shows account 7 with a credit balance

  # ---------------------------------------------------------------- the figures move by the right amount

  Scenario Outline: Booking <name> moves reported <figure> by <sign><amount>
    Given the books figures are noted
    When the accountant posts Dr account <dr> Cr account <cr> for <amount>
    Then reported <figure> <direction> by <amount>

    @case:110
    Examples:
      | name | dr | cr | amount | figure | direction | sign |
      | a cash sale | 1 | 9 | 50000 | revenue | rose | + |
    @case:111
    Examples:
      | name | dr | cr | amount | figure | direction | sign |
      | a cash sale | 1 | 9 | 50000 | assets | rose | + |
    @case:112
    Examples:
      | name | dr | cr | amount | figure | direction | sign |
      | a credit sale | 3 | 9 | 75000 | revenue | rose | + |
    @case:113
    Examples:
      | name | dr | cr | amount | figure | direction | sign |
      | a credit sale | 3 | 9 | 75000 | assets | rose | + |
    @case:114
    Examples:
      | name | dr | cr | amount | figure | direction | sign |
      | paying rent | 11 | 1 | 18000 | expenses | rose | + |
    @case:115
    Examples:
      | name | dr | cr | amount | figure | direction | sign |
      | paying rent | 11 | 1 | 18000 | assets | fell | - |
    @case:116
    Examples:
      | name | dr | cr | amount | figure | direction | sign |
      | paying salaries | 12 | 1 | 90000 | expenses | rose | + |
    @case:117
    Examples:
      | name | dr | cr | amount | figure | direction | sign |
      | the owner investing | 1 | 7 | 300000 | equity | rose | + |
    @case:118
    Examples:
      | name | dr | cr | amount | figure | direction | sign |
      | the owner investing | 1 | 7 | 300000 | assets | rose | + |
    @case:119
    Examples:
      | name | dr | cr | amount | figure | direction | sign |
      | taking a loan | 2 | 6 | 500000 | liabilities | rose | + |
    @case:120
    Examples:
      | name | dr | cr | amount | figure | direction | sign |
      | taking a loan | 2 | 6 | 500000 | assets | rose | + |
    @case:121
    Examples:
      | name | dr | cr | amount | figure | direction | sign |
      | buying inventory on credit | 4 | 5 | 200000 | liabilities | rose | + |
    @case:122
    Examples:
      | name | dr | cr | amount | figure | direction | sign |
      | buying inventory on credit | 4 | 5 | 200000 | assets | rose | + |
    @case:123
    Examples:
      | name | dr | cr | amount | figure | direction | sign |
      | paying a supplier | 5 | 1 | 80000 | liabilities | fell | - |
    @case:124
    Examples:
      | name | dr | cr | amount | figure | direction | sign |
      | paying a supplier | 5 | 1 | 80000 | assets | fell | - |
    @case:125
    Examples:
      | name | dr | cr | amount | figure | direction | sign |
      | a service sale for cash | 1 | 10 | 27000 | revenue | rose | + |
    @case:126
    Examples:
      | name | dr | cr | amount | figure | direction | sign |
      | paying utilities | 14 | 1 | 6400 | expenses | rose | + |
    @case:127
    Examples:
      | name | dr | cr | amount | figure | direction | sign |
      | repaying a loan | 6 | 2 | 100000 | liabilities | fell | - |

  Scenario Outline: Booking <name> moves reported net income by <amount>
    Given the books figures are noted
    When the accountant posts Dr account <dr> Cr account <cr> for <amount>
    Then reported net income <direction> by <amount>

    @case:128
    Examples:
      | name | dr | cr | amount | direction |
      | a cash sale | 1 | 9 | 50000 | rose |
    @case:129
    Examples:
      | name | dr | cr | amount | direction |
      | a credit sale | 3 | 9 | 40000 | rose |
    @case:130
    Examples:
      | name | dr | cr | amount | direction |
      | paying rent | 11 | 1 | 18000 | fell |
    @case:131
    Examples:
      | name | dr | cr | amount | direction |
      | paying salaries | 12 | 2 | 95000 | fell |
    @case:132
    Examples:
      | name | dr | cr | amount | direction |
      | a service sale | 1 | 10 | 27000 | rose |
    @case:133
    Examples:
      | name | dr | cr | amount | direction |
      | paying utilities | 14 | 1 | 6400 | fell |

  # ---------------------------------------------------------------- figures that must NOT move

  Scenario Outline: Booking <name> leaves reported <figure> unchanged
    Given the books figures are noted
    When the accountant posts Dr account <dr> Cr account <cr> for <amount>
    Then reported <figure> rose by 0

    @case:134
    Examples:
      | name | dr | cr | amount | figure |
      | collecting a receivable | 1 | 3 | 30000 | assets |
    @case:135
    Examples:
      | name | dr | cr | amount | figure |
      | depositing cash in the bank | 2 | 1 | 40000 | assets |
    @case:136
    Examples:
      | name | dr | cr | amount | figure |
      | a cash sale | 1 | 9 | 50000 | liabilities |
    @case:137
    Examples:
      | name | dr | cr | amount | figure |
      | a cash sale | 1 | 9 | 50000 | equity |
    @case:138
    Examples:
      | name | dr | cr | amount | figure |
      | taking a loan | 2 | 6 | 500000 | equity |
    @case:139
    Examples:
      | name | dr | cr | amount | figure |
      | paying rent | 11 | 1 | 18000 | liabilities |
    @case:140
    Examples:
      | name | dr | cr | amount | figure |
      | the owner investing | 1 | 7 | 300000 | revenue |

  # ---------------------------------------------------------------- the invariants hold after every kind of posting

  Scenario Outline: After booking <name> the books stay balanced and the equation holds
    When the accountant posts Dr account <dr> Cr account <cr> for <amount>
    And the trial balance is fetched
    Then the trial balance is balanced
    And the balance sheet still balances
    And the accounting equation still holds

    @case:141
    Examples:
      | name | dr | cr | amount |
      | a cash sale | 1 | 9 | 50000 |
    @case:142
    Examples:
      | name | dr | cr | amount |
      | a credit sale | 3 | 9 | 75000 |
    @case:143
    Examples:
      | name | dr | cr | amount |
      | paying rent | 11 | 1 | 18000 |
    @case:144
    Examples:
      | name | dr | cr | amount |
      | paying salaries | 12 | 1 | 120000 |
    @case:145
    Examples:
      | name | dr | cr | amount |
      | buying inventory on credit | 4 | 5 | 250000 |
    @case:146
    Examples:
      | name | dr | cr | amount |
      | paying a supplier | 5 | 1 | 80000 |
    @case:147
    Examples:
      | name | dr | cr | amount |
      | taking a loan | 2 | 6 | 500000 |
    @case:148
    Examples:
      | name | dr | cr | amount |
      | repaying a loan | 6 | 2 | 100000 |
    @case:149
    Examples:
      | name | dr | cr | amount |
      | the owner investing | 1 | 7 | 300000 |
    @case:150
    Examples:
      | name | dr | cr | amount |
      | a service sale for cash | 1 | 10 | 27000 |
    @case:151
    Examples:
      | name | dr | cr | amount |
      | paying utilities | 14 | 1 | 6400 |
    @case:152
    Examples:
      | name | dr | cr | amount |
      | buying supplies for cash | 13 | 1 | 9000 |
    @case:153
    Examples:
      | name | dr | cr | amount |
      | collecting to the bank | 2 | 3 | 15000 |
    @case:154
    Examples:
      | name | dr | cr | amount |
      | a large cash sale | 1 | 9 | 1000000 |
    @case:155
    Examples:
      | name | dr | cr | amount |
      | supplies on account | 13 | 5 | 5000 |

  Scenario Outline: More booking Dr <dr> Cr <cr> for <amount> keeps the equation holding
    When the accountant posts Dr account <dr> Cr account <cr> for <amount>
    And the accounting equation is fetched
    Then the accounting equation holds

    @case:336
    Examples:
      | dr | cr | amount |
      | 2 | 1 | 100 |
    @case:337
    Examples:
      | dr | cr | amount |
      | 3 | 1 | 999 |
    @case:338
    Examples:
      | dr | cr | amount |
      | 4 | 1 | 2500 |
    @case:339
    Examples:
      | dr | cr | amount |
      | 11 | 1 | 7777 |
    @case:340
    Examples:
      | dr | cr | amount |
      | 12 | 1 | 12345 |
    @case:341
    Examples:
      | dr | cr | amount |
      | 13 | 1 | 33333 |
    @case:342
    Examples:
      | dr | cr | amount |
      | 14 | 1 | 50000 |
    @case:343
    Examples:
      | dr | cr | amount |
      | 1 | 2 | 64000 |
    @case:344
    Examples:
      | dr | cr | amount |
      | 3 | 2 | 90909 |
    @case:345
    Examples:
      | dr | cr | amount |
      | 4 | 2 | 123456 |
    @case:346
    Examples:
      | dr | cr | amount |
      | 11 | 2 | 200000 |
    @case:347
    Examples:
      | dr | cr | amount |
      | 12 | 2 | 275000 |
    @case:348
    Examples:
      | dr | cr | amount |
      | 13 | 2 | 450000 |
    @case:349
    Examples:
      | dr | cr | amount |
      | 14 | 2 | 7 |
    @case:350
    Examples:
      | dr | cr | amount |
      | 1 | 5 | 64 |
    @case:351
    Examples:
      | dr | cr | amount |
      | 2 | 5 | 8888 |
    @case:352
    Examples:
      | dr | cr | amount |
      | 3 | 5 | 100 |
    @case:353
    Examples:
      | dr | cr | amount |
      | 4 | 5 | 999 |
    @case:354
    Examples:
      | dr | cr | amount |
      | 11 | 5 | 2500 |
    @case:355
    Examples:
      | dr | cr | amount |
      | 12 | 5 | 7777 |
    @case:356
    Examples:
      | dr | cr | amount |
      | 13 | 5 | 12345 |
    @case:357
    Examples:
      | dr | cr | amount |
      | 14 | 5 | 33333 |
    @case:358
    Examples:
      | dr | cr | amount |
      | 1 | 6 | 50000 |
    @case:359
    Examples:
      | dr | cr | amount |
      | 2 | 6 | 64000 |
    @case:360
    Examples:
      | dr | cr | amount |
      | 3 | 6 | 90909 |
    @case:361
    Examples:
      | dr | cr | amount |
      | 4 | 6 | 123456 |
    @case:362
    Examples:
      | dr | cr | amount |
      | 11 | 6 | 200000 |
    @case:363
    Examples:
      | dr | cr | amount |
      | 12 | 6 | 275000 |
    @case:364
    Examples:
      | dr | cr | amount |
      | 13 | 6 | 450000 |
    @case:365
    Examples:
      | dr | cr | amount |
      | 14 | 6 | 7 |
    @case:366
    Examples:
      | dr | cr | amount |
      | 1 | 7 | 64 |
    @case:367
    Examples:
      | dr | cr | amount |
      | 2 | 7 | 8888 |
    @case:368
    Examples:
      | dr | cr | amount |
      | 3 | 7 | 100 |
    @case:369
    Examples:
      | dr | cr | amount |
      | 4 | 7 | 999 |
    @case:370
    Examples:
      | dr | cr | amount |
      | 11 | 7 | 2500 |
    @case:371
    Examples:
      | dr | cr | amount |
      | 12 | 7 | 7777 |
    @case:372
    Examples:
      | dr | cr | amount |
      | 13 | 7 | 12345 |
    @case:373
    Examples:
      | dr | cr | amount |
      | 14 | 7 | 33333 |
    @case:374
    Examples:
      | dr | cr | amount |
      | 1 | 9 | 50000 |
    @case:375
    Examples:
      | dr | cr | amount |
      | 2 | 9 | 64000 |
    @case:376
    Examples:
      | dr | cr | amount |
      | 3 | 9 | 90909 |
    @case:377
    Examples:
      | dr | cr | amount |
      | 4 | 9 | 123456 |
    @case:378
    Examples:
      | dr | cr | amount |
      | 11 | 9 | 200000 |
    @case:379
    Examples:
      | dr | cr | amount |
      | 12 | 9 | 275000 |
    @case:380
    Examples:
      | dr | cr | amount |
      | 13 | 9 | 450000 |
    @case:381
    Examples:
      | dr | cr | amount |
      | 14 | 9 | 7 |
    @case:382
    Examples:
      | dr | cr | amount |
      | 1 | 10 | 64 |
    @case:383
    Examples:
      | dr | cr | amount |
      | 2 | 10 | 8888 |
    @case:384
    Examples:
      | dr | cr | amount |
      | 3 | 10 | 100 |
    @case:385
    Examples:
      | dr | cr | amount |
      | 4 | 10 | 999 |
    @case:386
    Examples:
      | dr | cr | amount |
      | 11 | 10 | 2500 |
    @case:387
    Examples:
      | dr | cr | amount |
      | 12 | 10 | 7777 |
    @case:388
    Examples:
      | dr | cr | amount |
      | 13 | 10 | 12345 |
    @case:389
    Examples:
      | dr | cr | amount |
      | 14 | 10 | 33333 |
    @case:390
    Examples:
      | dr | cr | amount |
      | 2 | 1 | 50000 |
    @case:391
    Examples:
      | dr | cr | amount |
      | 3 | 1 | 64000 |
    @case:392
    Examples:
      | dr | cr | amount |
      | 4 | 1 | 90909 |
    @case:393
    Examples:
      | dr | cr | amount |
      | 11 | 1 | 123456 |
    @case:394
    Examples:
      | dr | cr | amount |
      | 12 | 1 | 200000 |
    @case:395
    Examples:
      | dr | cr | amount |
      | 13 | 1 | 275000 |
    @case:396
    Examples:
      | dr | cr | amount |
      | 14 | 1 | 450000 |
    @case:397
    Examples:
      | dr | cr | amount |
      | 1 | 2 | 7 |

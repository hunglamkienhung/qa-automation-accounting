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

  Scenario Outline: Bulk Dr <dr> Cr <cr> for <amount> keeps the equation holding
    When the accountant posts Dr account <dr> Cr account <cr> for <amount>
    And the accounting equation is fetched
    Then the accounting equation holds

    @case:692
    Examples:
      | dr | cr | amount |
      | 2 | 1 | 11 |
    @case:693
    Examples:
      | dr | cr | amount |
      | 3 | 1 | 73 |
    @case:694
    Examples:
      | dr | cr | amount |
      | 4 | 1 | 149 |
    @case:695
    Examples:
      | dr | cr | amount |
      | 11 | 1 | 251 |
    @case:696
    Examples:
      | dr | cr | amount |
      | 12 | 1 | 499 |
    @case:697
    Examples:
      | dr | cr | amount |
      | 13 | 1 | 777 |
    @case:698
    Examples:
      | dr | cr | amount |
      | 14 | 1 | 1234 |
    @case:699
    Examples:
      | dr | cr | amount |
      | 2 | 1 | 2500 |
    @case:700
    Examples:
      | dr | cr | amount |
      | 3 | 1 | 4096 |
    @case:701
    Examples:
      | dr | cr | amount |
      | 4 | 1 | 7777 |
    @case:702
    Examples:
      | dr | cr | amount |
      | 1 | 2 | 9001 |
    @case:703
    Examples:
      | dr | cr | amount |
      | 3 | 2 | 12345 |
    @case:704
    Examples:
      | dr | cr | amount |
      | 4 | 2 | 20202 |
    @case:705
    Examples:
      | dr | cr | amount |
      | 11 | 2 | 33333 |
    @case:706
    Examples:
      | dr | cr | amount |
      | 12 | 2 | 45678 |
    @case:707
    Examples:
      | dr | cr | amount |
      | 13 | 2 | 64000 |
    @case:708
    Examples:
      | dr | cr | amount |
      | 14 | 2 | 88888 |
    @case:709
    Examples:
      | dr | cr | amount |
      | 1 | 2 | 100000 |
    @case:710
    Examples:
      | dr | cr | amount |
      | 3 | 2 | 123456 |
    @case:711
    Examples:
      | dr | cr | amount |
      | 4 | 2 | 175000 |
    @case:712
    Examples:
      | dr | cr | amount |
      | 1 | 5 | 222222 |
    @case:713
    Examples:
      | dr | cr | amount |
      | 2 | 5 | 275000 |
    @case:714
    Examples:
      | dr | cr | amount |
      | 3 | 5 | 300000 |
    @case:715
    Examples:
      | dr | cr | amount |
      | 4 | 5 | 375000 |
    @case:716
    Examples:
      | dr | cr | amount |
      | 11 | 5 | 420000 |
    @case:717
    Examples:
      | dr | cr | amount |
      | 12 | 5 | 499999 |
    @case:718
    Examples:
      | dr | cr | amount |
      | 13 | 5 | 64 |
    @case:719
    Examples:
      | dr | cr | amount |
      | 14 | 5 | 8 |
    @case:720
    Examples:
      | dr | cr | amount |
      | 1 | 5 | 3 |
    @case:721
    Examples:
      | dr | cr | amount |
      | 2 | 5 | 90909 |
    @case:722
    Examples:
      | dr | cr | amount |
      | 3 | 5 | 11 |
    @case:723
    Examples:
      | dr | cr | amount |
      | 4 | 5 | 73 |
    @case:724
    Examples:
      | dr | cr | amount |
      | 1 | 6 | 149 |
    @case:725
    Examples:
      | dr | cr | amount |
      | 2 | 6 | 251 |
    @case:726
    Examples:
      | dr | cr | amount |
      | 3 | 6 | 499 |
    @case:727
    Examples:
      | dr | cr | amount |
      | 4 | 6 | 777 |
    @case:728
    Examples:
      | dr | cr | amount |
      | 11 | 6 | 1234 |
    @case:729
    Examples:
      | dr | cr | amount |
      | 12 | 6 | 2500 |
    @case:730
    Examples:
      | dr | cr | amount |
      | 13 | 6 | 4096 |
    @case:731
    Examples:
      | dr | cr | amount |
      | 14 | 6 | 7777 |
    @case:732
    Examples:
      | dr | cr | amount |
      | 1 | 6 | 9001 |
    @case:733
    Examples:
      | dr | cr | amount |
      | 2 | 6 | 12345 |
    @case:734
    Examples:
      | dr | cr | amount |
      | 3 | 6 | 20202 |
    @case:735
    Examples:
      | dr | cr | amount |
      | 4 | 6 | 33333 |
    @case:736
    Examples:
      | dr | cr | amount |
      | 1 | 7 | 45678 |
    @case:737
    Examples:
      | dr | cr | amount |
      | 2 | 7 | 64000 |
    @case:738
    Examples:
      | dr | cr | amount |
      | 3 | 7 | 88888 |
    @case:739
    Examples:
      | dr | cr | amount |
      | 4 | 7 | 100000 |
    @case:740
    Examples:
      | dr | cr | amount |
      | 11 | 7 | 123456 |
    @case:741
    Examples:
      | dr | cr | amount |
      | 12 | 7 | 175000 |
    @case:742
    Examples:
      | dr | cr | amount |
      | 13 | 7 | 222222 |
    @case:743
    Examples:
      | dr | cr | amount |
      | 14 | 7 | 275000 |
    @case:744
    Examples:
      | dr | cr | amount |
      | 1 | 7 | 300000 |
    @case:745
    Examples:
      | dr | cr | amount |
      | 2 | 7 | 375000 |
    @case:746
    Examples:
      | dr | cr | amount |
      | 3 | 7 | 420000 |
    @case:747
    Examples:
      | dr | cr | amount |
      | 4 | 7 | 499999 |
    @case:748
    Examples:
      | dr | cr | amount |
      | 1 | 9 | 64 |
    @case:749
    Examples:
      | dr | cr | amount |
      | 2 | 9 | 8 |
    @case:750
    Examples:
      | dr | cr | amount |
      | 3 | 9 | 3 |
    @case:751
    Examples:
      | dr | cr | amount |
      | 4 | 9 | 90909 |
    @case:752
    Examples:
      | dr | cr | amount |
      | 11 | 9 | 11 |
    @case:753
    Examples:
      | dr | cr | amount |
      | 12 | 9 | 73 |
    @case:754
    Examples:
      | dr | cr | amount |
      | 13 | 9 | 149 |
    @case:755
    Examples:
      | dr | cr | amount |
      | 14 | 9 | 251 |
    @case:756
    Examples:
      | dr | cr | amount |
      | 1 | 9 | 499 |
    @case:757
    Examples:
      | dr | cr | amount |
      | 2 | 9 | 777 |
    @case:758
    Examples:
      | dr | cr | amount |
      | 3 | 9 | 1234 |
    @case:759
    Examples:
      | dr | cr | amount |
      | 4 | 9 | 2500 |
    @case:760
    Examples:
      | dr | cr | amount |
      | 1 | 10 | 4096 |
    @case:761
    Examples:
      | dr | cr | amount |
      | 2 | 10 | 7777 |
    @case:762
    Examples:
      | dr | cr | amount |
      | 3 | 10 | 9001 |
    @case:763
    Examples:
      | dr | cr | amount |
      | 4 | 10 | 12345 |
    @case:764
    Examples:
      | dr | cr | amount |
      | 11 | 10 | 20202 |
    @case:765
    Examples:
      | dr | cr | amount |
      | 12 | 10 | 33333 |
    @case:766
    Examples:
      | dr | cr | amount |
      | 13 | 10 | 45678 |
    @case:767
    Examples:
      | dr | cr | amount |
      | 14 | 10 | 64000 |
    @case:768
    Examples:
      | dr | cr | amount |
      | 1 | 10 | 88888 |
    @case:769
    Examples:
      | dr | cr | amount |
      | 2 | 10 | 100000 |
    @case:770
    Examples:
      | dr | cr | amount |
      | 3 | 10 | 123456 |
    @case:771
    Examples:
      | dr | cr | amount |
      | 4 | 10 | 175000 |
    @case:772
    Examples:
      | dr | cr | amount |
      | 1 | 5 | 222222 |
    @case:773
    Examples:
      | dr | cr | amount |
      | 2 | 5 | 275000 |
    @case:774
    Examples:
      | dr | cr | amount |
      | 3 | 5 | 300000 |
    @case:775
    Examples:
      | dr | cr | amount |
      | 4 | 5 | 375000 |
    @case:776
    Examples:
      | dr | cr | amount |
      | 11 | 5 | 420000 |
    @case:777
    Examples:
      | dr | cr | amount |
      | 12 | 5 | 499999 |
    @case:778
    Examples:
      | dr | cr | amount |
      | 13 | 5 | 64 |
    @case:779
    Examples:
      | dr | cr | amount |
      | 14 | 5 | 8 |
    @case:780
    Examples:
      | dr | cr | amount |
      | 1 | 5 | 3 |
    @case:781
    Examples:
      | dr | cr | amount |
      | 2 | 5 | 90909 |
    @case:782
    Examples:
      | dr | cr | amount |
      | 3 | 5 | 11 |
    @case:783
    Examples:
      | dr | cr | amount |
      | 4 | 5 | 73 |
    @case:784
    Examples:
      | dr | cr | amount |
      | 1 | 6 | 149 |
    @case:785
    Examples:
      | dr | cr | amount |
      | 2 | 6 | 251 |
    @case:786
    Examples:
      | dr | cr | amount |
      | 3 | 6 | 499 |
    @case:787
    Examples:
      | dr | cr | amount |
      | 4 | 6 | 777 |
    @case:788
    Examples:
      | dr | cr | amount |
      | 11 | 6 | 1234 |
    @case:789
    Examples:
      | dr | cr | amount |
      | 12 | 6 | 2500 |
    @case:790
    Examples:
      | dr | cr | amount |
      | 13 | 6 | 4096 |
    @case:791
    Examples:
      | dr | cr | amount |
      | 14 | 6 | 7777 |
    @case:792
    Examples:
      | dr | cr | amount |
      | 1 | 6 | 9001 |
    @case:793
    Examples:
      | dr | cr | amount |
      | 2 | 6 | 12345 |
    @case:794
    Examples:
      | dr | cr | amount |
      | 3 | 6 | 20202 |
    @case:795
    Examples:
      | dr | cr | amount |
      | 4 | 6 | 33333 |
    @case:796
    Examples:
      | dr | cr | amount |
      | 1 | 9 | 45678 |
    @case:797
    Examples:
      | dr | cr | amount |
      | 2 | 9 | 64000 |
    @case:798
    Examples:
      | dr | cr | amount |
      | 3 | 9 | 88888 |
    @case:799
    Examples:
      | dr | cr | amount |
      | 4 | 9 | 100000 |
    @case:800
    Examples:
      | dr | cr | amount |
      | 11 | 9 | 123456 |
    @case:801
    Examples:
      | dr | cr | amount |
      | 12 | 9 | 175000 |
    @case:802
    Examples:
      | dr | cr | amount |
      | 13 | 9 | 222222 |
    @case:803
    Examples:
      | dr | cr | amount |
      | 14 | 9 | 275000 |
    @case:804
    Examples:
      | dr | cr | amount |
      | 1 | 9 | 300000 |
    @case:805
    Examples:
      | dr | cr | amount |
      | 2 | 9 | 375000 |
    @case:806
    Examples:
      | dr | cr | amount |
      | 3 | 9 | 420000 |
    @case:807
    Examples:
      | dr | cr | amount |
      | 4 | 9 | 499999 |
    @case:808
    Examples:
      | dr | cr | amount |
      | 2 | 1 | 64 |
    @case:809
    Examples:
      | dr | cr | amount |
      | 3 | 1 | 8 |
    @case:810
    Examples:
      | dr | cr | amount |
      | 4 | 1 | 3 |
    @case:811
    Examples:
      | dr | cr | amount |
      | 11 | 1 | 90909 |
    @case:812
    Examples:
      | dr | cr | amount |
      | 12 | 1 | 11 |
    @case:813
    Examples:
      | dr | cr | amount |
      | 13 | 1 | 73 |
    @case:814
    Examples:
      | dr | cr | amount |
      | 14 | 1 | 149 |
    @case:815
    Examples:
      | dr | cr | amount |
      | 2 | 1 | 251 |
    @case:816
    Examples:
      | dr | cr | amount |
      | 3 | 1 | 499 |
    @case:817
    Examples:
      | dr | cr | amount |
      | 4 | 1 | 777 |
    @case:818
    Examples:
      | dr | cr | amount |
      | 1 | 2 | 1234 |
    @case:819
    Examples:
      | dr | cr | amount |
      | 3 | 2 | 2500 |
    @case:820
    Examples:
      | dr | cr | amount |
      | 4 | 2 | 4096 |
    @case:821
    Examples:
      | dr | cr | amount |
      | 11 | 2 | 7777 |
    @case:822
    Examples:
      | dr | cr | amount |
      | 12 | 2 | 9001 |
    @case:823
    Examples:
      | dr | cr | amount |
      | 13 | 2 | 12345 |
    @case:824
    Examples:
      | dr | cr | amount |
      | 14 | 2 | 20202 |
    @case:825
    Examples:
      | dr | cr | amount |
      | 1 | 2 | 33333 |
    @case:826
    Examples:
      | dr | cr | amount |
      | 3 | 2 | 45678 |
    @case:827
    Examples:
      | dr | cr | amount |
      | 4 | 2 | 64000 |
    @case:828
    Examples:
      | dr | cr | amount |
      | 1 | 5 | 88888 |
    @case:829
    Examples:
      | dr | cr | amount |
      | 2 | 5 | 100000 |
    @case:830
    Examples:
      | dr | cr | amount |
      | 3 | 5 | 123456 |
    @case:831
    Examples:
      | dr | cr | amount |
      | 4 | 5 | 175000 |

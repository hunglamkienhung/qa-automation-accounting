@module:02-mini-books-journal @be @api @books @journal
Feature: Posting journal entries

  A journal entry is a set of debit and credit lines whose debits equal its
  credits, in whole cents, dated on a business day, against active accounts that
  share a currency. It is idempotent by key. These scenarios post the common
  transactions a small business books, and reject the entries a bookkeeper must
  never accept.

  Background:
    Given the store is open and the service is reachable
    And an accountant

  # ---------------------------------------------------------------- happy path

  @case:49 @priority:high
  Scenario: A balanced two-line entry posts
    When the accountant posts Dr account 1 Cr account 9 for 50000
    Then the entry is posted
    And the entry response balances

  @case:50 @priority:high
  Scenario: A posted entry is given a number and two lines
    When the accountant posts Dr account 1 Cr account 9 for 30000
    Then the entry has a number
    And the entry lists 2 lines

  @case:51 @priority:high
  Scenario: A three-line entry that balances posts
    When the accountant posts a split entry debiting account 1 by 60000 and account 2 by 40000 crediting account 9 by 100000
    Then the entry is posted
    And the entry response balances
    And the entry lists 3 lines

  @case:52 @priority:medium
  Scenario: A posted entry can be read back
    When the accountant posts Dr account 1 Cr account 9 for 20000
    And the accountant reads the entry
    Then the entry reads back with balanced lines

  @case:53 @priority:medium
  Scenario: The entry list includes what was posted
    When the accountant posts Dr account 1 Cr account 9 for 20000
    And the accountant lists the entries
    Then the entry list includes the posted entry

  # ---------------------------------------------------------------- refusals a bookkeeper must make

  @case:54 @priority:high
  Scenario: An entry whose debits do not equal its credits is refused
    When the accountant posts an unbalanced entry of Dr 100 Cr 50
    Then the request is refused with code "unbalanced"

  @case:55 @priority:high
  Scenario: An entry with a single line is refused
    When the accountant posts a single-line entry
    Then the request is refused with code "too_few_lines"

  @case:56 @priority:high
  Scenario: An entry dated on a weekend is refused
    When the accountant posts Dr account 1 Cr account 9 for 1000 dated 2024-01-06
    Then the request is refused with code "non_business_day"

  @case:57 @priority:medium
  Scenario: An entry with a malformed date is a bad request
    When the accountant posts Dr account 1 Cr account 9 for 1000 dated 06-01-2024
    Then the request is refused with status 400

  @case:58 @priority:high
  Scenario: An entry touching an archived account is refused
    When the accountant posts Dr account 16 Cr account 9 for 1000
    Then the request is refused with code "inactive_account"

  @case:59 @priority:high
  Scenario: An entry mixing currencies is refused
    When the accountant posts Dr account 1 Cr account 15 for 1000
    Then the request is refused with code "currency_mismatch"

  @case:60 @priority:medium
  Scenario: An entry to an account that does not exist is not found
    When the accountant posts Dr account 999 Cr account 9 for 1000
    Then the request is refused with status 404

  @case:61 @priority:medium
  Scenario: An entry with a zero amount is a bad request
    When the accountant posts Dr account 1 Cr account 9 for 0
    Then the request is refused with status 400

  @case:62 @priority:medium
  Scenario: An entry with a negative amount is a bad request
    When the accountant posts Dr account 1 Cr account 9 for -100
    Then the request is refused with status 400

  @case:63 @priority:high
  Scenario: Posting without a token is unauthenticated
    When an anonymous caller posts Dr account 1 Cr account 9 for 1000
    Then the request is refused with status 401

  @case:64 @priority:high
  Scenario: A forged token cannot post
    When a forged token posts Dr account 1 Cr account 9 for 1000
    Then the request is refused with status 401

  # ---------------------------------------------------------------- idempotency

  @case:65 @priority:high
  Scenario: A repeated post with one key makes one entry
    When the accountant posts Dr account 1 Cr account 9 for 20000 with key "je-abc-1"
    And the accountant posts again with key "je-abc-1"
    Then both posts are the same entry

  # ---------------------------------------------------------------- business days (weekends refused, weekdays accepted)

  Scenario Outline: An entry dated <date> (<what>) is <verdict>
    When the accountant posts Dr account 1 Cr account 9 for 1000 dated <date>
    Then the entry is <verdict>

    @case:66
    Examples:
      | date | what | verdict |
      | 2024-01-06 | Saturday | refused |
    @case:67
    Examples:
      | date | what | verdict |
      | 2024-01-07 | Sunday | refused |
    @case:68
    Examples:
      | date | what | verdict |
      | 2024-01-08 | Monday | posted |
    @case:69
    Examples:
      | date | what | verdict |
      | 2024-03-09 | Saturday | refused |
    @case:70
    Examples:
      | date | what | verdict |
      | 2024-03-10 | Sunday | refused |
    @case:71
    Examples:
      | date | what | verdict |
      | 2024-03-11 | Monday | posted |
    @case:72
    Examples:
      | date | what | verdict |
      | 2024-06-14 | Friday | posted |
    @case:73
    Examples:
      | date | what | verdict |
      | 2024-06-15 | Saturday | refused |
    @case:74
    Examples:
      | date | what | verdict |
      | 2024-12-31 | Tuesday | posted |
    @case:75
    Examples:
      | date | what | verdict |
      | 2024-11-30 | Saturday | refused |

  # ---------------------------------------------------------------- the common transactions of a small business

  Scenario Outline: Booking <name> (Dr <dr> Cr <cr> for <amount>) posts and balances
    When the accountant posts Dr account <dr> Cr account <cr> for <amount>
    Then the entry is posted
    And the entry response balances

    @case:76
    Examples:
      | name | dr | cr | amount |
      | a cash sale | 1 | 9 | 50000 |
    @case:77
    Examples:
      | name | dr | cr | amount |
      | a credit sale | 3 | 9 | 75000 |
    @case:78
    Examples:
      | name | dr | cr | amount |
      | receiving on account | 1 | 3 | 30000 |
    @case:79
    Examples:
      | name | dr | cr | amount |
      | a service sale on account | 3 | 10 | 42000 |
    @case:80
    Examples:
      | name | dr | cr | amount |
      | paying rent | 11 | 1 | 18000 |
    @case:81
    Examples:
      | name | dr | cr | amount |
      | paying salaries | 12 | 1 | 120000 |
    @case:82
    Examples:
      | name | dr | cr | amount |
      | paying utilities | 14 | 1 | 6400 |
    @case:83
    Examples:
      | name | dr | cr | amount |
      | buying supplies for cash | 13 | 1 | 9000 |
    @case:84
    Examples:
      | name | dr | cr | amount |
      | buying inventory on credit | 4 | 5 | 250000 |
    @case:85
    Examples:
      | name | dr | cr | amount |
      | paying a supplier | 5 | 1 | 80000 |
    @case:86
    Examples:
      | name | dr | cr | amount |
      | taking a loan into the bank | 2 | 6 | 500000 |
    @case:87
    Examples:
      | name | dr | cr | amount |
      | repaying part of the loan | 6 | 2 | 100000 |
    @case:88
    Examples:
      | name | dr | cr | amount |
      | the owner investing capital | 1 | 7 | 300000 |
    @case:89
    Examples:
      | name | dr | cr | amount |
      | depositing cash into the bank | 2 | 1 | 40000 |
    @case:90
    Examples:
      | name | dr | cr | amount |
      | withdrawing cash from the bank | 1 | 2 | 25000 |
    @case:91
    Examples:
      | name | dr | cr | amount |
      | a bank service sale | 2 | 10 | 33000 |
    @case:92
    Examples:
      | name | dr | cr | amount |
      | supplies used on account | 13 | 5 | 5000 |
    @case:93
    Examples:
      | name | dr | cr | amount |
      | utilities on account | 14 | 5 | 4200 |
    @case:94
    Examples:
      | name | dr | cr | amount |
      | rent on account | 11 | 5 | 18000 |
    @case:95
    Examples:
      | name | dr | cr | amount |
      | a large cash sale | 1 | 9 | 1000000 |
    @case:96
    Examples:
      | name | dr | cr | amount |
      | a tiny cash sale | 1 | 9 | 1 |
    @case:97
    Examples:
      | name | dr | cr | amount |
      | salaries from the bank | 12 | 2 | 95000 |
    @case:98
    Examples:
      | name | dr | cr | amount |
      | inventory for cash | 4 | 1 | 60000 |
    @case:99
    Examples:
      | name | dr | cr | amount |
      | a service sale for cash | 1 | 10 | 27000 |
    @case:100
    Examples:
      | name | dr | cr | amount |
      | collecting a receivable to the bank | 2 | 3 | 15000 |

  Scenario Outline: More booking Dr <dr> Cr <cr> for <amount> posts and balances
    When the accountant posts Dr account <dr> Cr account <cr> for <amount>
    Then the entry is posted
    And the entry response balances

    @case:264
    Examples:
      | dr | cr | amount |
      | 2 | 1 | 100 |
    @case:265
    Examples:
      | dr | cr | amount |
      | 3 | 1 | 999 |
    @case:266
    Examples:
      | dr | cr | amount |
      | 4 | 1 | 2500 |
    @case:267
    Examples:
      | dr | cr | amount |
      | 11 | 1 | 7777 |
    @case:268
    Examples:
      | dr | cr | amount |
      | 12 | 1 | 12345 |
    @case:269
    Examples:
      | dr | cr | amount |
      | 13 | 1 | 33333 |
    @case:270
    Examples:
      | dr | cr | amount |
      | 14 | 1 | 50000 |
    @case:271
    Examples:
      | dr | cr | amount |
      | 1 | 2 | 64000 |
    @case:272
    Examples:
      | dr | cr | amount |
      | 3 | 2 | 90909 |
    @case:273
    Examples:
      | dr | cr | amount |
      | 4 | 2 | 123456 |
    @case:274
    Examples:
      | dr | cr | amount |
      | 11 | 2 | 200000 |
    @case:275
    Examples:
      | dr | cr | amount |
      | 12 | 2 | 275000 |
    @case:276
    Examples:
      | dr | cr | amount |
      | 13 | 2 | 450000 |
    @case:277
    Examples:
      | dr | cr | amount |
      | 14 | 2 | 7 |
    @case:278
    Examples:
      | dr | cr | amount |
      | 1 | 5 | 64 |
    @case:279
    Examples:
      | dr | cr | amount |
      | 2 | 5 | 8888 |
    @case:280
    Examples:
      | dr | cr | amount |
      | 3 | 5 | 100 |
    @case:281
    Examples:
      | dr | cr | amount |
      | 4 | 5 | 999 |
    @case:282
    Examples:
      | dr | cr | amount |
      | 11 | 5 | 2500 |
    @case:283
    Examples:
      | dr | cr | amount |
      | 12 | 5 | 7777 |
    @case:284
    Examples:
      | dr | cr | amount |
      | 13 | 5 | 12345 |
    @case:285
    Examples:
      | dr | cr | amount |
      | 14 | 5 | 33333 |
    @case:286
    Examples:
      | dr | cr | amount |
      | 1 | 6 | 50000 |
    @case:287
    Examples:
      | dr | cr | amount |
      | 2 | 6 | 64000 |
    @case:288
    Examples:
      | dr | cr | amount |
      | 3 | 6 | 90909 |
    @case:289
    Examples:
      | dr | cr | amount |
      | 4 | 6 | 123456 |
    @case:290
    Examples:
      | dr | cr | amount |
      | 11 | 6 | 200000 |
    @case:291
    Examples:
      | dr | cr | amount |
      | 12 | 6 | 275000 |
    @case:292
    Examples:
      | dr | cr | amount |
      | 13 | 6 | 450000 |
    @case:293
    Examples:
      | dr | cr | amount |
      | 14 | 6 | 7 |
    @case:294
    Examples:
      | dr | cr | amount |
      | 1 | 7 | 64 |
    @case:295
    Examples:
      | dr | cr | amount |
      | 2 | 7 | 8888 |
    @case:296
    Examples:
      | dr | cr | amount |
      | 3 | 7 | 100 |
    @case:297
    Examples:
      | dr | cr | amount |
      | 4 | 7 | 999 |
    @case:298
    Examples:
      | dr | cr | amount |
      | 11 | 7 | 2500 |
    @case:299
    Examples:
      | dr | cr | amount |
      | 12 | 7 | 7777 |
    @case:300
    Examples:
      | dr | cr | amount |
      | 13 | 7 | 12345 |
    @case:301
    Examples:
      | dr | cr | amount |
      | 14 | 7 | 33333 |
    @case:302
    Examples:
      | dr | cr | amount |
      | 1 | 9 | 50000 |
    @case:303
    Examples:
      | dr | cr | amount |
      | 2 | 9 | 64000 |
    @case:304
    Examples:
      | dr | cr | amount |
      | 3 | 9 | 90909 |
    @case:305
    Examples:
      | dr | cr | amount |
      | 4 | 9 | 123456 |
    @case:306
    Examples:
      | dr | cr | amount |
      | 11 | 9 | 200000 |
    @case:307
    Examples:
      | dr | cr | amount |
      | 12 | 9 | 275000 |
    @case:308
    Examples:
      | dr | cr | amount |
      | 13 | 9 | 450000 |
    @case:309
    Examples:
      | dr | cr | amount |
      | 14 | 9 | 7 |
    @case:310
    Examples:
      | dr | cr | amount |
      | 1 | 10 | 64 |
    @case:311
    Examples:
      | dr | cr | amount |
      | 2 | 10 | 8888 |
    @case:312
    Examples:
      | dr | cr | amount |
      | 3 | 10 | 100 |
    @case:313
    Examples:
      | dr | cr | amount |
      | 4 | 10 | 999 |
    @case:314
    Examples:
      | dr | cr | amount |
      | 11 | 10 | 2500 |
    @case:315
    Examples:
      | dr | cr | amount |
      | 12 | 10 | 7777 |
    @case:316
    Examples:
      | dr | cr | amount |
      | 13 | 10 | 12345 |
    @case:317
    Examples:
      | dr | cr | amount |
      | 14 | 10 | 33333 |
    @case:318
    Examples:
      | dr | cr | amount |
      | 2 | 1 | 50000 |
    @case:319
    Examples:
      | dr | cr | amount |
      | 3 | 1 | 64000 |
    @case:320
    Examples:
      | dr | cr | amount |
      | 4 | 1 | 90909 |
    @case:321
    Examples:
      | dr | cr | amount |
      | 11 | 1 | 123456 |
    @case:322
    Examples:
      | dr | cr | amount |
      | 12 | 1 | 200000 |
    @case:323
    Examples:
      | dr | cr | amount |
      | 13 | 1 | 275000 |
    @case:324
    Examples:
      | dr | cr | amount |
      | 14 | 1 | 450000 |
    @case:325
    Examples:
      | dr | cr | amount |
      | 1 | 2 | 7 |
    @case:326
    Examples:
      | dr | cr | amount |
      | 3 | 2 | 64 |
    @case:327
    Examples:
      | dr | cr | amount |
      | 4 | 2 | 8888 |
    @case:328
    Examples:
      | dr | cr | amount |
      | 11 | 2 | 100 |
    @case:329
    Examples:
      | dr | cr | amount |
      | 12 | 2 | 999 |
    @case:330
    Examples:
      | dr | cr | amount |
      | 13 | 2 | 2500 |
    @case:331
    Examples:
      | dr | cr | amount |
      | 14 | 2 | 7777 |
    @case:332
    Examples:
      | dr | cr | amount |
      | 1 | 5 | 12345 |
    @case:333
    Examples:
      | dr | cr | amount |
      | 2 | 5 | 33333 |
    @case:334
    Examples:
      | dr | cr | amount |
      | 3 | 5 | 50000 |
    @case:335
    Examples:
      | dr | cr | amount |
      | 4 | 5 | 64000 |

  Scenario Outline: Bulk balanced posting Dr <dr> Cr <cr> for <amount>
    When the accountant posts Dr account <dr> Cr account <cr> for <amount>
    Then the entry is posted
    And the entry response balances

    @case:512
    Examples:
      | dr | cr | amount |
      | 2 | 1 | 11 |
    @case:513
    Examples:
      | dr | cr | amount |
      | 3 | 1 | 73 |
    @case:514
    Examples:
      | dr | cr | amount |
      | 4 | 1 | 149 |
    @case:515
    Examples:
      | dr | cr | amount |
      | 11 | 1 | 251 |
    @case:516
    Examples:
      | dr | cr | amount |
      | 12 | 1 | 499 |
    @case:517
    Examples:
      | dr | cr | amount |
      | 13 | 1 | 777 |
    @case:518
    Examples:
      | dr | cr | amount |
      | 14 | 1 | 1234 |
    @case:519
    Examples:
      | dr | cr | amount |
      | 2 | 1 | 2500 |
    @case:520
    Examples:
      | dr | cr | amount |
      | 3 | 1 | 4096 |
    @case:521
    Examples:
      | dr | cr | amount |
      | 4 | 1 | 7777 |
    @case:522
    Examples:
      | dr | cr | amount |
      | 1 | 2 | 9001 |
    @case:523
    Examples:
      | dr | cr | amount |
      | 3 | 2 | 12345 |
    @case:524
    Examples:
      | dr | cr | amount |
      | 4 | 2 | 20202 |
    @case:525
    Examples:
      | dr | cr | amount |
      | 11 | 2 | 33333 |
    @case:526
    Examples:
      | dr | cr | amount |
      | 12 | 2 | 45678 |
    @case:527
    Examples:
      | dr | cr | amount |
      | 13 | 2 | 64000 |
    @case:528
    Examples:
      | dr | cr | amount |
      | 14 | 2 | 88888 |
    @case:529
    Examples:
      | dr | cr | amount |
      | 1 | 2 | 100000 |
    @case:530
    Examples:
      | dr | cr | amount |
      | 3 | 2 | 123456 |
    @case:531
    Examples:
      | dr | cr | amount |
      | 4 | 2 | 175000 |
    @case:532
    Examples:
      | dr | cr | amount |
      | 1 | 5 | 222222 |
    @case:533
    Examples:
      | dr | cr | amount |
      | 2 | 5 | 275000 |
    @case:534
    Examples:
      | dr | cr | amount |
      | 3 | 5 | 300000 |
    @case:535
    Examples:
      | dr | cr | amount |
      | 4 | 5 | 375000 |
    @case:536
    Examples:
      | dr | cr | amount |
      | 11 | 5 | 420000 |
    @case:537
    Examples:
      | dr | cr | amount |
      | 12 | 5 | 499999 |
    @case:538
    Examples:
      | dr | cr | amount |
      | 13 | 5 | 64 |
    @case:539
    Examples:
      | dr | cr | amount |
      | 14 | 5 | 8 |
    @case:540
    Examples:
      | dr | cr | amount |
      | 1 | 5 | 3 |
    @case:541
    Examples:
      | dr | cr | amount |
      | 2 | 5 | 90909 |
    @case:542
    Examples:
      | dr | cr | amount |
      | 3 | 5 | 11 |
    @case:543
    Examples:
      | dr | cr | amount |
      | 4 | 5 | 73 |
    @case:544
    Examples:
      | dr | cr | amount |
      | 1 | 6 | 149 |
    @case:545
    Examples:
      | dr | cr | amount |
      | 2 | 6 | 251 |
    @case:546
    Examples:
      | dr | cr | amount |
      | 3 | 6 | 499 |
    @case:547
    Examples:
      | dr | cr | amount |
      | 4 | 6 | 777 |
    @case:548
    Examples:
      | dr | cr | amount |
      | 11 | 6 | 1234 |
    @case:549
    Examples:
      | dr | cr | amount |
      | 12 | 6 | 2500 |
    @case:550
    Examples:
      | dr | cr | amount |
      | 13 | 6 | 4096 |
    @case:551
    Examples:
      | dr | cr | amount |
      | 14 | 6 | 7777 |
    @case:552
    Examples:
      | dr | cr | amount |
      | 1 | 6 | 9001 |
    @case:553
    Examples:
      | dr | cr | amount |
      | 2 | 6 | 12345 |
    @case:554
    Examples:
      | dr | cr | amount |
      | 3 | 6 | 20202 |
    @case:555
    Examples:
      | dr | cr | amount |
      | 4 | 6 | 33333 |
    @case:556
    Examples:
      | dr | cr | amount |
      | 1 | 7 | 45678 |
    @case:557
    Examples:
      | dr | cr | amount |
      | 2 | 7 | 64000 |
    @case:558
    Examples:
      | dr | cr | amount |
      | 3 | 7 | 88888 |
    @case:559
    Examples:
      | dr | cr | amount |
      | 4 | 7 | 100000 |
    @case:560
    Examples:
      | dr | cr | amount |
      | 11 | 7 | 123456 |
    @case:561
    Examples:
      | dr | cr | amount |
      | 12 | 7 | 175000 |
    @case:562
    Examples:
      | dr | cr | amount |
      | 13 | 7 | 222222 |
    @case:563
    Examples:
      | dr | cr | amount |
      | 14 | 7 | 275000 |
    @case:564
    Examples:
      | dr | cr | amount |
      | 1 | 7 | 300000 |
    @case:565
    Examples:
      | dr | cr | amount |
      | 2 | 7 | 375000 |
    @case:566
    Examples:
      | dr | cr | amount |
      | 3 | 7 | 420000 |
    @case:567
    Examples:
      | dr | cr | amount |
      | 4 | 7 | 499999 |
    @case:568
    Examples:
      | dr | cr | amount |
      | 1 | 9 | 64 |
    @case:569
    Examples:
      | dr | cr | amount |
      | 2 | 9 | 8 |
    @case:570
    Examples:
      | dr | cr | amount |
      | 3 | 9 | 3 |
    @case:571
    Examples:
      | dr | cr | amount |
      | 4 | 9 | 90909 |
    @case:572
    Examples:
      | dr | cr | amount |
      | 11 | 9 | 11 |
    @case:573
    Examples:
      | dr | cr | amount |
      | 12 | 9 | 73 |
    @case:574
    Examples:
      | dr | cr | amount |
      | 13 | 9 | 149 |
    @case:575
    Examples:
      | dr | cr | amount |
      | 14 | 9 | 251 |
    @case:576
    Examples:
      | dr | cr | amount |
      | 1 | 9 | 499 |
    @case:577
    Examples:
      | dr | cr | amount |
      | 2 | 9 | 777 |
    @case:578
    Examples:
      | dr | cr | amount |
      | 3 | 9 | 1234 |
    @case:579
    Examples:
      | dr | cr | amount |
      | 4 | 9 | 2500 |
    @case:580
    Examples:
      | dr | cr | amount |
      | 1 | 10 | 4096 |
    @case:581
    Examples:
      | dr | cr | amount |
      | 2 | 10 | 7777 |
    @case:582
    Examples:
      | dr | cr | amount |
      | 3 | 10 | 9001 |
    @case:583
    Examples:
      | dr | cr | amount |
      | 4 | 10 | 12345 |
    @case:584
    Examples:
      | dr | cr | amount |
      | 11 | 10 | 20202 |
    @case:585
    Examples:
      | dr | cr | amount |
      | 12 | 10 | 33333 |
    @case:586
    Examples:
      | dr | cr | amount |
      | 13 | 10 | 45678 |
    @case:587
    Examples:
      | dr | cr | amount |
      | 14 | 10 | 64000 |
    @case:588
    Examples:
      | dr | cr | amount |
      | 1 | 10 | 88888 |
    @case:589
    Examples:
      | dr | cr | amount |
      | 2 | 10 | 100000 |
    @case:590
    Examples:
      | dr | cr | amount |
      | 3 | 10 | 123456 |
    @case:591
    Examples:
      | dr | cr | amount |
      | 4 | 10 | 175000 |
    @case:592
    Examples:
      | dr | cr | amount |
      | 1 | 5 | 222222 |
    @case:593
    Examples:
      | dr | cr | amount |
      | 2 | 5 | 275000 |
    @case:594
    Examples:
      | dr | cr | amount |
      | 3 | 5 | 300000 |
    @case:595
    Examples:
      | dr | cr | amount |
      | 4 | 5 | 375000 |
    @case:596
    Examples:
      | dr | cr | amount |
      | 11 | 5 | 420000 |
    @case:597
    Examples:
      | dr | cr | amount |
      | 12 | 5 | 499999 |
    @case:598
    Examples:
      | dr | cr | amount |
      | 13 | 5 | 64 |
    @case:599
    Examples:
      | dr | cr | amount |
      | 14 | 5 | 8 |
    @case:600
    Examples:
      | dr | cr | amount |
      | 1 | 5 | 3 |
    @case:601
    Examples:
      | dr | cr | amount |
      | 2 | 5 | 90909 |
    @case:602
    Examples:
      | dr | cr | amount |
      | 3 | 5 | 11 |
    @case:603
    Examples:
      | dr | cr | amount |
      | 4 | 5 | 73 |
    @case:604
    Examples:
      | dr | cr | amount |
      | 1 | 6 | 149 |
    @case:605
    Examples:
      | dr | cr | amount |
      | 2 | 6 | 251 |
    @case:606
    Examples:
      | dr | cr | amount |
      | 3 | 6 | 499 |
    @case:607
    Examples:
      | dr | cr | amount |
      | 4 | 6 | 777 |
    @case:608
    Examples:
      | dr | cr | amount |
      | 11 | 6 | 1234 |
    @case:609
    Examples:
      | dr | cr | amount |
      | 12 | 6 | 2500 |
    @case:610
    Examples:
      | dr | cr | amount |
      | 13 | 6 | 4096 |
    @case:611
    Examples:
      | dr | cr | amount |
      | 14 | 6 | 7777 |
    @case:612
    Examples:
      | dr | cr | amount |
      | 1 | 6 | 9001 |
    @case:613
    Examples:
      | dr | cr | amount |
      | 2 | 6 | 12345 |
    @case:614
    Examples:
      | dr | cr | amount |
      | 3 | 6 | 20202 |
    @case:615
    Examples:
      | dr | cr | amount |
      | 4 | 6 | 33333 |
    @case:616
    Examples:
      | dr | cr | amount |
      | 1 | 9 | 45678 |
    @case:617
    Examples:
      | dr | cr | amount |
      | 2 | 9 | 64000 |
    @case:618
    Examples:
      | dr | cr | amount |
      | 3 | 9 | 88888 |
    @case:619
    Examples:
      | dr | cr | amount |
      | 4 | 9 | 100000 |
    @case:620
    Examples:
      | dr | cr | amount |
      | 11 | 9 | 123456 |
    @case:621
    Examples:
      | dr | cr | amount |
      | 12 | 9 | 175000 |
    @case:622
    Examples:
      | dr | cr | amount |
      | 13 | 9 | 222222 |
    @case:623
    Examples:
      | dr | cr | amount |
      | 14 | 9 | 275000 |
    @case:624
    Examples:
      | dr | cr | amount |
      | 1 | 9 | 300000 |
    @case:625
    Examples:
      | dr | cr | amount |
      | 2 | 9 | 375000 |
    @case:626
    Examples:
      | dr | cr | amount |
      | 3 | 9 | 420000 |
    @case:627
    Examples:
      | dr | cr | amount |
      | 4 | 9 | 499999 |
    @case:628
    Examples:
      | dr | cr | amount |
      | 2 | 1 | 64 |
    @case:629
    Examples:
      | dr | cr | amount |
      | 3 | 1 | 8 |
    @case:630
    Examples:
      | dr | cr | amount |
      | 4 | 1 | 3 |
    @case:631
    Examples:
      | dr | cr | amount |
      | 11 | 1 | 90909 |
    @case:632
    Examples:
      | dr | cr | amount |
      | 12 | 1 | 11 |
    @case:633
    Examples:
      | dr | cr | amount |
      | 13 | 1 | 73 |
    @case:634
    Examples:
      | dr | cr | amount |
      | 14 | 1 | 149 |
    @case:635
    Examples:
      | dr | cr | amount |
      | 2 | 1 | 251 |
    @case:636
    Examples:
      | dr | cr | amount |
      | 3 | 1 | 499 |
    @case:637
    Examples:
      | dr | cr | amount |
      | 4 | 1 | 777 |
    @case:638
    Examples:
      | dr | cr | amount |
      | 1 | 2 | 1234 |
    @case:639
    Examples:
      | dr | cr | amount |
      | 3 | 2 | 2500 |
    @case:640
    Examples:
      | dr | cr | amount |
      | 4 | 2 | 4096 |
    @case:641
    Examples:
      | dr | cr | amount |
      | 11 | 2 | 7777 |
    @case:642
    Examples:
      | dr | cr | amount |
      | 12 | 2 | 9001 |
    @case:643
    Examples:
      | dr | cr | amount |
      | 13 | 2 | 12345 |
    @case:644
    Examples:
      | dr | cr | amount |
      | 14 | 2 | 20202 |
    @case:645
    Examples:
      | dr | cr | amount |
      | 1 | 2 | 33333 |
    @case:646
    Examples:
      | dr | cr | amount |
      | 3 | 2 | 45678 |
    @case:647
    Examples:
      | dr | cr | amount |
      | 4 | 2 | 64000 |
    @case:648
    Examples:
      | dr | cr | amount |
      | 1 | 5 | 88888 |
    @case:649
    Examples:
      | dr | cr | amount |
      | 2 | 5 | 100000 |
    @case:650
    Examples:
      | dr | cr | amount |
      | 3 | 5 | 123456 |
    @case:651
    Examples:
      | dr | cr | amount |
      | 4 | 5 | 175000 |
    @case:652
    Examples:
      | dr | cr | amount |
      | 11 | 5 | 222222 |
    @case:653
    Examples:
      | dr | cr | amount |
      | 12 | 5 | 275000 |
    @case:654
    Examples:
      | dr | cr | amount |
      | 13 | 5 | 300000 |
    @case:655
    Examples:
      | dr | cr | amount |
      | 14 | 5 | 375000 |
    @case:656
    Examples:
      | dr | cr | amount |
      | 1 | 5 | 420000 |
    @case:657
    Examples:
      | dr | cr | amount |
      | 2 | 5 | 499999 |
    @case:658
    Examples:
      | dr | cr | amount |
      | 3 | 5 | 64 |
    @case:659
    Examples:
      | dr | cr | amount |
      | 4 | 5 | 8 |
    @case:660
    Examples:
      | dr | cr | amount |
      | 1 | 6 | 3 |
    @case:661
    Examples:
      | dr | cr | amount |
      | 2 | 6 | 90909 |
    @case:662
    Examples:
      | dr | cr | amount |
      | 3 | 6 | 11 |
    @case:663
    Examples:
      | dr | cr | amount |
      | 4 | 6 | 73 |
    @case:664
    Examples:
      | dr | cr | amount |
      | 11 | 6 | 149 |
    @case:665
    Examples:
      | dr | cr | amount |
      | 12 | 6 | 251 |
    @case:666
    Examples:
      | dr | cr | amount |
      | 13 | 6 | 499 |
    @case:667
    Examples:
      | dr | cr | amount |
      | 14 | 6 | 777 |
    @case:668
    Examples:
      | dr | cr | amount |
      | 1 | 6 | 1234 |
    @case:669
    Examples:
      | dr | cr | amount |
      | 2 | 6 | 2500 |
    @case:670
    Examples:
      | dr | cr | amount |
      | 3 | 6 | 4096 |
    @case:671
    Examples:
      | dr | cr | amount |
      | 4 | 6 | 7777 |
    @case:672
    Examples:
      | dr | cr | amount |
      | 1 | 7 | 9001 |
    @case:673
    Examples:
      | dr | cr | amount |
      | 2 | 7 | 12345 |
    @case:674
    Examples:
      | dr | cr | amount |
      | 3 | 7 | 20202 |
    @case:675
    Examples:
      | dr | cr | amount |
      | 4 | 7 | 33333 |
    @case:676
    Examples:
      | dr | cr | amount |
      | 11 | 7 | 45678 |
    @case:677
    Examples:
      | dr | cr | amount |
      | 12 | 7 | 64000 |
    @case:678
    Examples:
      | dr | cr | amount |
      | 13 | 7 | 88888 |
    @case:679
    Examples:
      | dr | cr | amount |
      | 14 | 7 | 100000 |
    @case:680
    Examples:
      | dr | cr | amount |
      | 1 | 7 | 123456 |
    @case:681
    Examples:
      | dr | cr | amount |
      | 2 | 7 | 175000 |
    @case:682
    Examples:
      | dr | cr | amount |
      | 3 | 7 | 222222 |
    @case:683
    Examples:
      | dr | cr | amount |
      | 4 | 7 | 275000 |
    @case:684
    Examples:
      | dr | cr | amount |
      | 1 | 9 | 300000 |
    @case:685
    Examples:
      | dr | cr | amount |
      | 2 | 9 | 375000 |
    @case:686
    Examples:
      | dr | cr | amount |
      | 3 | 9 | 420000 |
    @case:687
    Examples:
      | dr | cr | amount |
      | 4 | 9 | 499999 |
    @case:688
    Examples:
      | dr | cr | amount |
      | 11 | 9 | 64 |
    @case:689
    Examples:
      | dr | cr | amount |
      | 12 | 9 | 8 |
    @case:690
    Examples:
      | dr | cr | amount |
      | 13 | 9 | 3 |
    @case:691
    Examples:
      | dr | cr | amount |
      | 14 | 9 | 90909 |

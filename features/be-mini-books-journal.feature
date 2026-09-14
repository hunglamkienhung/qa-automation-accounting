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
    @case:612
    Examples:
      | dr | cr | amount |
      | 1 | 2 | 250 |
    @case:613
    Examples:
      | dr | cr | amount |
      | 1 | 3 | 263 |
    @case:614
    Examples:
      | dr | cr | amount |
      | 1 | 4 | 276 |
    @case:615
    Examples:
      | dr | cr | amount |
      | 1 | 5 | 289 |
    @case:616
    Examples:
      | dr | cr | amount |
      | 1 | 6 | 302 |
    @case:617
    Examples:
      | dr | cr | amount |
      | 1 | 7 | 315 |
    @case:618
    Examples:
      | dr | cr | amount |
      | 1 | 8 | 328 |
    @case:619
    Examples:
      | dr | cr | amount |
      | 1 | 9 | 341 |
    @case:620
    Examples:
      | dr | cr | amount |
      | 1 | 10 | 354 |
    @case:621
    Examples:
      | dr | cr | amount |
      | 1 | 11 | 367 |
    @case:622
    Examples:
      | dr | cr | amount |
      | 1 | 12 | 380 |
    @case:623
    Examples:
      | dr | cr | amount |
      | 1 | 13 | 393 |
    @case:624
    Examples:
      | dr | cr | amount |
      | 1 | 14 | 406 |
    @case:625
    Examples:
      | dr | cr | amount |
      | 2 | 1 | 419 |
    @case:626
    Examples:
      | dr | cr | amount |
      | 2 | 3 | 432 |
    @case:627
    Examples:
      | dr | cr | amount |
      | 2 | 4 | 445 |
    @case:628
    Examples:
      | dr | cr | amount |
      | 2 | 5 | 458 |
    @case:629
    Examples:
      | dr | cr | amount |
      | 2 | 6 | 471 |
    @case:630
    Examples:
      | dr | cr | amount |
      | 2 | 7 | 484 |
    @case:631
    Examples:
      | dr | cr | amount |
      | 2 | 8 | 497 |
    @case:632
    Examples:
      | dr | cr | amount |
      | 2 | 9 | 510 |
    @case:633
    Examples:
      | dr | cr | amount |
      | 2 | 10 | 523 |
    @case:634
    Examples:
      | dr | cr | amount |
      | 2 | 11 | 536 |
    @case:635
    Examples:
      | dr | cr | amount |
      | 2 | 12 | 549 |
    @case:636
    Examples:
      | dr | cr | amount |
      | 2 | 13 | 562 |
    @case:637
    Examples:
      | dr | cr | amount |
      | 2 | 14 | 575 |
    @case:638
    Examples:
      | dr | cr | amount |
      | 3 | 1 | 588 |
    @case:639
    Examples:
      | dr | cr | amount |
      | 3 | 2 | 601 |
    @case:640
    Examples:
      | dr | cr | amount |
      | 3 | 4 | 614 |
    @case:641
    Examples:
      | dr | cr | amount |
      | 3 | 5 | 627 |
    @case:642
    Examples:
      | dr | cr | amount |
      | 3 | 6 | 640 |
    @case:643
    Examples:
      | dr | cr | amount |
      | 3 | 7 | 653 |
    @case:644
    Examples:
      | dr | cr | amount |
      | 3 | 8 | 666 |
    @case:645
    Examples:
      | dr | cr | amount |
      | 3 | 9 | 679 |
    @case:646
    Examples:
      | dr | cr | amount |
      | 3 | 10 | 692 |
    @case:647
    Examples:
      | dr | cr | amount |
      | 3 | 11 | 705 |
    @case:648
    Examples:
      | dr | cr | amount |
      | 3 | 12 | 718 |
    @case:649
    Examples:
      | dr | cr | amount |
      | 3 | 13 | 731 |
    @case:650
    Examples:
      | dr | cr | amount |
      | 3 | 14 | 744 |
    @case:651
    Examples:
      | dr | cr | amount |
      | 4 | 1 | 757 |
    @case:652
    Examples:
      | dr | cr | amount |
      | 4 | 2 | 770 |
    @case:653
    Examples:
      | dr | cr | amount |
      | 4 | 3 | 783 |
    @case:654
    Examples:
      | dr | cr | amount |
      | 4 | 5 | 796 |
    @case:655
    Examples:
      | dr | cr | amount |
      | 4 | 6 | 809 |
    @case:656
    Examples:
      | dr | cr | amount |
      | 4 | 7 | 822 |
    @case:657
    Examples:
      | dr | cr | amount |
      | 4 | 8 | 835 |
    @case:658
    Examples:
      | dr | cr | amount |
      | 4 | 9 | 848 |
    @case:659
    Examples:
      | dr | cr | amount |
      | 4 | 10 | 861 |
    @case:660
    Examples:
      | dr | cr | amount |
      | 4 | 11 | 874 |
    @case:661
    Examples:
      | dr | cr | amount |
      | 4 | 12 | 887 |
    @case:662
    Examples:
      | dr | cr | amount |
      | 4 | 13 | 900 |
    @case:663
    Examples:
      | dr | cr | amount |
      | 4 | 14 | 913 |
    @case:664
    Examples:
      | dr | cr | amount |
      | 5 | 1 | 926 |
    @case:665
    Examples:
      | dr | cr | amount |
      | 5 | 2 | 939 |
    @case:666
    Examples:
      | dr | cr | amount |
      | 5 | 3 | 952 |
    @case:667
    Examples:
      | dr | cr | amount |
      | 5 | 4 | 965 |
    @case:668
    Examples:
      | dr | cr | amount |
      | 5 | 6 | 978 |
    @case:669
    Examples:
      | dr | cr | amount |
      | 5 | 7 | 991 |
    @case:670
    Examples:
      | dr | cr | amount |
      | 5 | 8 | 1004 |
    @case:671
    Examples:
      | dr | cr | amount |
      | 5 | 9 | 1017 |
    @case:672
    Examples:
      | dr | cr | amount |
      | 5 | 10 | 1030 |
    @case:673
    Examples:
      | dr | cr | amount |
      | 5 | 11 | 1043 |
    @case:674
    Examples:
      | dr | cr | amount |
      | 5 | 12 | 1056 |
    @case:675
    Examples:
      | dr | cr | amount |
      | 5 | 13 | 1069 |
    @case:676
    Examples:
      | dr | cr | amount |
      | 5 | 14 | 1082 |
    @case:677
    Examples:
      | dr | cr | amount |
      | 6 | 1 | 1095 |
    @case:678
    Examples:
      | dr | cr | amount |
      | 6 | 2 | 1108 |
    @case:679
    Examples:
      | dr | cr | amount |
      | 6 | 3 | 1121 |
    @case:680
    Examples:
      | dr | cr | amount |
      | 6 | 4 | 1134 |
    @case:681
    Examples:
      | dr | cr | amount |
      | 6 | 5 | 1147 |
    @case:682
    Examples:
      | dr | cr | amount |
      | 6 | 7 | 1160 |
    @case:683
    Examples:
      | dr | cr | amount |
      | 6 | 8 | 1173 |
    @case:684
    Examples:
      | dr | cr | amount |
      | 6 | 9 | 1186 |
    @case:685
    Examples:
      | dr | cr | amount |
      | 6 | 10 | 1199 |
    @case:686
    Examples:
      | dr | cr | amount |
      | 6 | 11 | 1212 |
    @case:687
    Examples:
      | dr | cr | amount |
      | 6 | 12 | 1225 |
    @case:688
    Examples:
      | dr | cr | amount |
      | 6 | 13 | 1238 |
    @case:689
    Examples:
      | dr | cr | amount |
      | 6 | 14 | 1251 |
    @case:690
    Examples:
      | dr | cr | amount |
      | 7 | 1 | 1264 |
    @case:691
    Examples:
      | dr | cr | amount |
      | 7 | 2 | 1277 |
    @case:692
    Examples:
      | dr | cr | amount |
      | 7 | 3 | 1290 |
    @case:693
    Examples:
      | dr | cr | amount |
      | 7 | 4 | 1303 |
    @case:694
    Examples:
      | dr | cr | amount |
      | 7 | 5 | 1316 |
    @case:695
    Examples:
      | dr | cr | amount |
      | 7 | 6 | 1329 |
    @case:696
    Examples:
      | dr | cr | amount |
      | 7 | 8 | 1342 |
    @case:697
    Examples:
      | dr | cr | amount |
      | 7 | 9 | 1355 |
    @case:698
    Examples:
      | dr | cr | amount |
      | 7 | 10 | 1368 |
    @case:699
    Examples:
      | dr | cr | amount |
      | 7 | 11 | 1381 |
    @case:700
    Examples:
      | dr | cr | amount |
      | 7 | 12 | 1394 |
    @case:701
    Examples:
      | dr | cr | amount |
      | 7 | 13 | 1407 |
    @case:702
    Examples:
      | dr | cr | amount |
      | 7 | 14 | 1420 |
    @case:703
    Examples:
      | dr | cr | amount |
      | 8 | 1 | 1433 |
    @case:704
    Examples:
      | dr | cr | amount |
      | 8 | 2 | 1446 |
    @case:705
    Examples:
      | dr | cr | amount |
      | 8 | 3 | 1459 |
    @case:706
    Examples:
      | dr | cr | amount |
      | 8 | 4 | 1472 |
    @case:707
    Examples:
      | dr | cr | amount |
      | 8 | 5 | 1485 |
    @case:708
    Examples:
      | dr | cr | amount |
      | 8 | 6 | 1498 |
    @case:709
    Examples:
      | dr | cr | amount |
      | 8 | 7 | 1511 |
    @case:710
    Examples:
      | dr | cr | amount |
      | 8 | 9 | 1524 |
    @case:711
    Examples:
      | dr | cr | amount |
      | 8 | 10 | 1537 |


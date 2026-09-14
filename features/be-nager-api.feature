@module:07-nager-api @be @api @nager
Feature: Nager.Date's public holiday API, read-only, and the settlement date built on it

  A business posts and settles on business days. The business-day rule is a pure
  function -- the first business day after a date, skipping weekends and public
  holidays -- so its scenarios are deterministic and need no network. The live
  scenarios read Nager.Date over HTTPS with no key: a past year's holiday list is
  settled, so it is asserted by value and for stability across two reads. Feeding
  a real holiday list into the rule computes a settlement date that skips both
  weekends and public holidays, end to end.

  On a transport failure -- the API unreachable, timing out, or serving a
  challenge page -- the live scenarios report Blocked, never Failed: the calendar
  service being unreachable is not the calendar being wrong.

  # ---------------------------------------------------------------- the business-day rule (pure)

  @case:216 @priority:high
  Scenario: A Saturday is a weekend
    When the weekend flag of 2024-03-02 is checked
    Then it is a weekend

  @case:217 @priority:high
  Scenario: A Monday is a weekday
    When the weekend flag of 2024-03-04 is checked
    Then it is a weekday

  Scenario Outline: The business day after <date> with no holidays is <expected>
    When the business day after <date> is computed with no holidays
    Then the business day is <expected>

    @case:218
    Examples:
      | date | expected |
      | 2024-01-05 | 2024-01-08 |
    @case:219
    Examples:
      | date | expected |
      | 2024-01-06 | 2024-01-08 |
    @case:220
    Examples:
      | date | expected |
      | 2024-01-07 | 2024-01-08 |
    @case:221
    Examples:
      | date | expected |
      | 2024-03-01 | 2024-03-04 |
    @case:222
    Examples:
      | date | expected |
      | 2024-03-08 | 2024-03-11 |
    @case:223
    Examples:
      | date | expected |
      | 2024-03-09 | 2024-03-11 |
    @case:224
    Examples:
      | date | expected |
      | 2024-03-10 | 2024-03-11 |
    @case:225
    Examples:
      | date | expected |
      | 2024-03-15 | 2024-03-18 |
    @case:226
    Examples:
      | date | expected |
      | 2024-06-28 | 2024-07-01 |
    @case:227
    Examples:
      | date | expected |
      | 2024-12-30 | 2024-12-31 |
    @case:228
    Examples:
      | date | expected |
      | 2024-06-14 | 2024-06-17 |
    @case:229
    Examples:
      | date | expected |
      | 2024-09-13 | 2024-09-16 |
    @case:230
    Examples:
      | date | expected |
      | 2024-10-11 | 2024-10-14 |
    @case:231
    Examples:
      | date | expected |
      | 2024-04-30 | 2024-05-01 |
    @case:232
    Examples:
      | date | expected |
      | 2024-02-29 | 2024-03-01 |
    @case:233
    Examples:
      | date | expected |
      | 2024-07-05 | 2024-07-08 |
    @case:234
    Examples:
      | date | expected |
      | 2024-11-29 | 2024-12-02 |
    @case:235
    Examples:
      | date | expected |
      | 2024-08-16 | 2024-08-19 |
    @case:236
    Examples:
      | date | expected |
      | 2024-05-31 | 2024-06-03 |
    @case:237
    Examples:
      | date | expected |
      | 2024-02-15 | 2024-02-16 |

  # ---------------------------------------------------------------- the live holiday list (value-stable)

  @case:238 @priority:high
  Scenario: The US holiday list answers for 2024
    When the holidays for 2024 in US are fetched
    Then the holiday list is non-empty

  @case:239 @priority:high
  Scenario: The US 2024 holiday list has the expected number of entries
    When the holidays for 2024 in US are fetched
    Then the holiday list has 17 entries

  @case:240 @priority:high
  Scenario: Independence Day is in the US 2024 list
    When the holidays for 2024 in US are fetched
    Then the list includes a holiday on 2024-07-04

  @case:241 @priority:high
  Scenario: Christmas Day is in the US 2024 list
    When the holidays for 2024 in US are fetched
    Then the list includes a holiday on 2024-12-25

  @case:242 @priority:medium
  Scenario: New Year's Day is in the US 2024 list
    When the holidays for 2024 in US are fetched
    Then the list includes a holiday on 2024-01-01

  @case:243 @priority:medium
  Scenario: Thanksgiving is in the US 2024 list
    When the holidays for 2024 in US are fetched
    Then the list includes a holiday on 2024-11-28

  @case:244 @priority:medium
  Scenario: Every holiday has a date and a name
    When the holidays for 2024 in US are fetched
    Then every holiday has a date and a name

  @case:245 @priority:high
  Scenario: The holiday list is stable across two reads
    When the holidays for 2024 in US are fetched
    And the holidays for 2024 in US are fetched again
    Then both holiday reads return identical dates

  @case:246 @priority:medium
  Scenario: The UK holiday list answers for 2024
    When the holidays for 2024 in GB are fetched
    Then the holiday list has 13 entries

  @case:247 @priority:low
  Scenario: The available-countries list includes the US and the UK
    When the available countries are fetched
    Then the available countries include US and GB

  # ---------------------------------------------------------------- settlement, end to end (live + rule)

  Scenario Outline: Settlement after <date> in the US is <expected>
    When the settlement date after <date> in US is computed
    Then the settlement date is <expected>
    And the settlement date is a business day

    @case:248
    Examples:
      | date | expected |
      | 2024-07-03 | 2024-07-05 |
    @case:249
    Examples:
      | date | expected |
      | 2024-12-24 | 2024-12-26 |
    @case:250
    Examples:
      | date | expected |
      | 2024-05-24 | 2024-05-28 |
    @case:251
    Examples:
      | date | expected |
      | 2024-11-27 | 2024-11-29 |
    @case:252
    Examples:
      | date | expected |
      | 2024-08-15 | 2024-08-16 |
    @case:253
    Examples:
      | date | expected |
      | 2024-01-31 | 2024-02-01 |
    @case:254
    Examples:
      | date | expected |
      | 2024-08-30 | 2024-09-03 |
    @case:255
    Examples:
      | date | expected |
      | 2024-06-18 | 2024-06-20 |
    @case:256
    Examples:
      | date | expected |
      | 2024-02-16 | 2024-02-20 |
    @case:257
    Examples:
      | date | expected |
      | 2024-10-13 | 2024-10-15 |
    @case:258
    Examples:
      | date | expected |
      | 2024-09-01 | 2024-09-03 |
    @case:259
    Examples:
      | date | expected |
      | 2024-01-12 | 2024-01-16 |
    @case:260
    Examples:
      | date | expected |
      | 2024-05-17 | 2024-05-20 |
    @case:261
    Examples:
      | date | expected |
      | 2024-11-10 | 2024-11-12 |
    @case:262
    Examples:
      | date | expected |
      | 2024-06-30 | 2024-07-01 |
    @case:263
    Examples:
      | date | expected |
      | 2024-12-25 | 2024-12-26 |

  Scenario Outline: More: the business day after <date> with no holidays is <expected>
    When the business day after <date> is computed with no holidays
    Then the business day is <expected>

    @case:478
    Examples:
      | date | expected |
      | 2024-01-15 | 2024-01-16 |
    @case:479
    Examples:
      | date | expected |
      | 2024-01-19 | 2024-01-22 |
    @case:480
    Examples:
      | date | expected |
      | 2024-01-22 | 2024-01-23 |
    @case:481
    Examples:
      | date | expected |
      | 2024-02-02 | 2024-02-05 |
    @case:482
    Examples:
      | date | expected |
      | 2024-02-09 | 2024-02-12 |
    @case:483
    Examples:
      | date | expected |
      | 2024-02-20 | 2024-02-21 |
    @case:484
    Examples:
      | date | expected |
      | 2024-03-22 | 2024-03-25 |
    @case:485
    Examples:
      | date | expected |
      | 2024-04-05 | 2024-04-08 |
    @case:486
    Examples:
      | date | expected |
      | 2024-04-12 | 2024-04-15 |
    @case:487
    Examples:
      | date | expected |
      | 2024-05-03 | 2024-05-06 |
    @case:488
    Examples:
      | date | expected |
      | 2024-05-10 | 2024-05-13 |
    @case:489
    Examples:
      | date | expected |
      | 2024-06-07 | 2024-06-10 |
    @case:490
    Examples:
      | date | expected |
      | 2024-07-12 | 2024-07-15 |
    @case:491
    Examples:
      | date | expected |
      | 2024-08-02 | 2024-08-05 |
    @case:492
    Examples:
      | date | expected |
      | 2024-08-23 | 2024-08-26 |
    @case:493
    Examples:
      | date | expected |
      | 2024-09-06 | 2024-09-09 |
    @case:494
    Examples:
      | date | expected |
      | 2024-09-20 | 2024-09-23 |
    @case:495
    Examples:
      | date | expected |
      | 2024-10-04 | 2024-10-07 |
    @case:496
    Examples:
      | date | expected |
      | 2024-10-25 | 2024-10-28 |
    @case:497
    Examples:
      | date | expected |
      | 2024-11-08 | 2024-11-11 |

  Scenario Outline: More settlement: after <date> in the US is <expected>
    When the settlement date after <date> in US is computed
    Then the settlement date is <expected>
    And the settlement date is a business day

    @case:498
    Examples:
      | date | expected |
      | 2024-01-14 | 2024-01-16 |
    @case:499
    Examples:
      | date | expected |
      | 2024-02-14 | 2024-02-15 |
    @case:500
    Examples:
      | date | expected |
      | 2024-03-28 | 2024-04-01 |
    @case:501
    Examples:
      | date | expected |
      | 2024-04-18 | 2024-04-19 |
    @case:502
    Examples:
      | date | expected |
      | 2024-05-23 | 2024-05-24 |
    @case:503
    Examples:
      | date | expected |
      | 2024-06-13 | 2024-06-14 |
    @case:504
    Examples:
      | date | expected |
      | 2024-07-02 | 2024-07-03 |
    @case:505
    Examples:
      | date | expected |
      | 2024-09-30 | 2024-10-01 |
    @case:506
    Examples:
      | date | expected |
      | 2024-10-31 | 2024-11-01 |
    @case:507
    Examples:
      | date | expected |
      | 2024-11-26 | 2024-11-27 |
    @case:508
    Examples:
      | date | expected |
      | 2024-12-23 | 2024-12-24 |
    @case:509
    Examples:
      | date | expected |
      | 2024-12-30 | 2024-12-31 |
    @case:510
    Examples:
      | date | expected |
      | 2024-06-19 | 2024-06-20 |
    @case:511
    Examples:
      | date | expected |
      | 2024-11-11 | 2024-11-12 |

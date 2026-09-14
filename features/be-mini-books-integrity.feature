@module:04-mini-books-integrity @be @api @books @integrity
Feature: The books stay in balance, always

  Double entry means the accounting equation holds after every posting, the
  trial balance's debits equal its credits, and a reversal restores the figures
  it undoes. And because each entry is numbered inside one IMMEDIATE transaction,
  the journal is numbered by a gapless, duplicate-free sequence even when many
  entries post at once, and a repeated post with one idempotency key posts once.

  Background:
    Given the store is open and the service is reachable
    And an accountant

  # ---------------------------------------------------------------- the equation over a sequence

  @case:156 @priority:high
  Scenario: A chain of postings keeps the equation holding and the ledger balanced
    When the accountant posts Dr account 1 Cr account 9 for 50000
    And the accountant posts Dr account 11 Cr account 1 for 18000
    And the accountant posts Dr account 4 Cr account 5 for 40000
    And the accountant posts Dr account 2 Cr account 6 for 200000
    And the accounting equation is fetched
    Then the accounting equation holds
    And the whole ledger is balanced

  @case:157 @priority:high
  Scenario: A three-line entry keeps the equation holding
    When the accountant posts a split entry debiting account 1 by 60000 and account 2 by 40000 crediting account 9 by 100000
    And the accounting equation is fetched
    Then the accounting equation holds

  # ---------------------------------------------------------------- reversals restore

  @case:158 @priority:high
  Scenario: Reversing an entry restores the figures it moved
    Given the books figures are noted
    And a cash sale of 50000
    And the entry is reversed by the admin
    Then the figures are back to what was noted

  @case:159 @priority:high
  Scenario: A reversal keeps the equation holding
    Given a cash sale of 30000
    And the entry is reversed by the admin
    When the accounting equation is fetched
    Then the accounting equation holds

  @case:160 @priority:high
  Scenario: An entry cannot be reversed twice
    Given a cash sale of 30000
    And the entry is reversed by the admin
    When the admin reverses the entry
    Then the request is refused with code "bad_state"

  @case:161 @priority:high
  Scenario: A reversal cannot itself be reversed
    Given a cash sale of 30000
    And the entry is reversed by the admin
    When the admin reverses the reversal
    Then the request is refused with code "bad_state"

  @case:162 @priority:high
  Scenario: Only the admin may reverse an entry
    Given a cash sale of 30000
    When the accountant tries to reverse the entry
    Then the response status is 401

  @case:163 @priority:medium
  Scenario: Reversing an entry that does not exist is not found
    When the admin reverses entry 999999
    Then the response status is 404

  # ---------------------------------------------------------------- gapless numbering under concurrency (the point)

  @case:164 @priority:high
  Scenario: Many entries posting at once are numbered without a gap or a duplicate
    When 10 accountants post distinct entries at once
    Then every racing post succeeds
    And the entry numbers are gapless and unique
    And 10 entries were added

  @case:165 @priority:high
  Scenario: A repeated post racing with one key posts exactly once
    When 8 accountants post the same entry with one key at once
    Then all the racing posts share one entry

  @case:166 @priority:high
  Scenario: The trial balance stays balanced after a burst of concurrent posting
    When 12 accountants post distinct entries at once
    And the trial balance is fetched
    Then the trial balance is balanced
    And the entry numbers are gapless and unique

  Scenario Outline: A burst of <racers> concurrent entries stays gapless
    When <racers> accountants post distinct entries at once
    Then every racing post succeeds
    And the entry numbers are gapless and unique
    And <racers> entries were added

    @case:167
    Examples:
      | racers |
      | 5 |
    @case:168
    Examples:
      | racers |
      | 9 |
    @case:169
    Examples:
      | racers |
      | 15 |
    @case:170
    Examples:
      | racers |
      | 20 |
    @case:171
    Examples:
      | racers |
      | 7 |

  Scenario Outline: <racers> racing idempotent posts make one entry
    When <racers> accountants post the same entry with one key at once
    Then all the racing posts share one entry

    @case:172
    Examples:
      | racers |
      | 4 |
    @case:173
    Examples:
      | racers |
      | 8 |
    @case:174
    Examples:
      | racers |
      | 12 |
    @case:932
    Examples:
      | racers |
      | 2 |
    @case:933
    Examples:
      | racers |
      | 3 |
    @case:934
    Examples:
      | racers |
      | 4 |
    @case:935
    Examples:
      | racers |
      | 5 |
    @case:936
    Examples:
      | racers |
      | 6 |
    @case:937
    Examples:
      | racers |
      | 7 |
    @case:938
    Examples:
      | racers |
      | 8 |
    @case:939
    Examples:
      | racers |
      | 9 |
    @case:940
    Examples:
      | racers |
      | 10 |
    @case:941
    Examples:
      | racers |
      | 11 |
    @case:942
    Examples:
      | racers |
      | 12 |
    @case:943
    Examples:
      | racers |
      | 13 |
    @case:944
    Examples:
      | racers |
      | 14 |
    @case:945
    Examples:
      | racers |
      | 15 |
    @case:946
    Examples:
      | racers |
      | 16 |
    @case:947
    Examples:
      | racers |
      | 17 |
    @case:948
    Examples:
      | racers |
      | 18 |
    @case:949
    Examples:
      | racers |
      | 19 |
    @case:950
    Examples:
      | racers |
      | 20 |
    @case:951
    Examples:
      | racers |
      | 21 |
    @case:952
    Examples:
      | racers |
      | 22 |
    @case:953
    Examples:
      | racers |
      | 23 |
    @case:954
    Examples:
      | racers |
      | 24 |
    @case:955
    Examples:
      | racers |
      | 25 |
    @case:956
    Examples:
      | racers |
      | 26 |
    @case:957
    Examples:
      | racers |
      | 27 |
    @case:958
    Examples:
      | racers |
      | 28 |
    @case:959
    Examples:
      | racers |
      | 29 |
    @case:960
    Examples:
      | racers |
      | 30 |
    @case:961
    Examples:
      | racers |
      | 31 |
    @case:962
    Examples:
      | racers |
      | 32 |
    @case:963
    Examples:
      | racers |
      | 33 |
    @case:964
    Examples:
      | racers |
      | 34 |
    @case:965
    Examples:
      | racers |
      | 35 |


  # ---------------------------------------------------------------- normal balances by type

  Scenario Outline: A <type> account's balance carries its normal sign
    Given the balance of account <acc> is noted
    When the accountant posts <entry>
    Then account <acc> balance rose by <delta>

    @case:175
    Examples:
      | type | acc | entry | delta |
      | asset debited | 2 | Dr account 2 Cr account 9 for 10000 | 10000 |
    @case:176
    Examples:
      | type | acc | entry | delta |
      | expense debited | 11 | Dr account 11 Cr account 1 for 8000 | 8000 |
    @case:177
    Examples:
      | type | acc | entry | delta |
      | liability credited | 6 | Dr account 2 Cr account 6 for 50000 | 50000 |
    @case:178
    Examples:
      | type | acc | entry | delta |
      | equity credited | 7 | Dr account 1 Cr account 7 for 70000 | 70000 |
    @case:179
    Examples:
      | type | acc | entry | delta |
      | revenue credited | 9 | Dr account 1 Cr account 9 for 15000 | 15000 |

  Scenario Outline: A larger burst of <racers> concurrent entries stays gapless
    When <racers> accountants post distinct entries at once
    Then every racing post succeeds
    And the entry numbers are gapless and unique
    And <racers> entries were added

    @case:456
    Examples:
      | racers |
      | 6 |
    @case:457
    Examples:
      | racers |
      | 8 |
    @case:458
    Examples:
      | racers |
      | 11 |
    @case:459
    Examples:
      | racers |
      | 13 |
    @case:460
    Examples:
      | racers |
      | 14 |
    @case:461
    Examples:
      | racers |
      | 16 |
    @case:462
    Examples:
      | racers |
      | 18 |
    @case:463
    Examples:
      | racers |
      | 22 |
    @case:464
    Examples:
      | racers |
      | 5 |
    @case:465
    Examples:
      | racers |
      | 9 |
    @case:466
    Examples:
      | racers |
      | 17 |
    @case:467
    Examples:
      | racers |
      | 25 |
    @case:966
    Examples:
      | racers |
      | 2 |
    @case:967
    Examples:
      | racers |
      | 3 |
    @case:968
    Examples:
      | racers |
      | 4 |
    @case:969
    Examples:
      | racers |
      | 5 |
    @case:970
    Examples:
      | racers |
      | 6 |
    @case:971
    Examples:
      | racers |
      | 7 |
    @case:972
    Examples:
      | racers |
      | 8 |
    @case:973
    Examples:
      | racers |
      | 9 |
    @case:974
    Examples:
      | racers |
      | 10 |
    @case:975
    Examples:
      | racers |
      | 11 |
    @case:976
    Examples:
      | racers |
      | 12 |
    @case:977
    Examples:
      | racers |
      | 13 |
    @case:978
    Examples:
      | racers |
      | 14 |
    @case:979
    Examples:
      | racers |
      | 15 |
    @case:980
    Examples:
      | racers |
      | 16 |
    @case:981
    Examples:
      | racers |
      | 17 |
    @case:982
    Examples:
      | racers |
      | 18 |
    @case:983
    Examples:
      | racers |
      | 19 |
    @case:984
    Examples:
      | racers |
      | 20 |
    @case:985
    Examples:
      | racers |
      | 21 |
    @case:986
    Examples:
      | racers |
      | 22 |
    @case:987
    Examples:
      | racers |
      | 23 |
    @case:988
    Examples:
      | racers |
      | 24 |
    @case:989
    Examples:
      | racers |
      | 25 |
    @case:990
    Examples:
      | racers |
      | 26 |
    @case:991
    Examples:
      | racers |
      | 27 |
    @case:992
    Examples:
      | racers |
      | 28 |
    @case:993
    Examples:
      | racers |
      | 29 |
    @case:994
    Examples:
      | racers |
      | 30 |
    @case:995
    Examples:
      | racers |
      | 31 |
    @case:996
    Examples:
      | racers |
      | 32 |
    @case:997
    Examples:
      | racers |
      | 33 |
    @case:998
    Examples:
      | racers |
      | 34 |
    @case:999
    Examples:
      | racers |
      | 35 |
    @case:1000
    Examples:
      | racers |
      | 36 |


  Scenario Outline: More <racers> racing idempotent posts make one entry
    When <racers> accountants post the same entry with one key at once
    Then all the racing posts share one entry

    @case:468
    Examples:
      | racers |
      | 3 |
    @case:469
    Examples:
      | racers |
      | 5 |
    @case:470
    Examples:
      | racers |
      | 6 |
    @case:471
    Examples:
      | racers |
      | 7 |
    @case:472
    Examples:
      | racers |
      | 9 |
    @case:473
    Examples:
      | racers |
      | 10 |
    @case:474
    Examples:
      | racers |
      | 11 |
    @case:475
    Examples:
      | racers |
      | 14 |
    @case:476
    Examples:
      | racers |
      | 16 |
    @case:477
    Examples:
      | racers |
      | 20 |

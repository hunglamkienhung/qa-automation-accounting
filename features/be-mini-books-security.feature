@module:05-mini-books-security @be @api @books @security
Feature: The mini-books authorization surface, probed like an attacker

  Accountants and the admin share one API, so the token check on each route is
  what keeps the books safe. This tier probes those checks: posting and reading
  entries need an accountant token; reversing an entry and the admin reports need
  the admin token; the chart of accounts is public reference data. A request with
  no token, a forged token, or the wrong role must be refused, with positive
  controls so a refusal is a real gate.

  Background:
    Given the store is open and the service is reachable

  # ---------------------------------------------------------------- the posting gate

  @case:180 @priority:high
  Scenario: Posting an entry requires a token
    When an entry is posted with no token
    Then the response status is 401
    And the response is an error with code "unauthenticated"

  @case:181 @priority:high
  Scenario: A forged token cannot post
    When an entry is posted with a forged token
    Then the response status is 401

  @case:182 @priority:high
  Scenario: Reading an entry requires a token
    When entry 1 is read with no token
    Then the response status is 401

  # ---------------------------------------------------------------- the admin gate

  @case:183 @priority:high
  Scenario: An accountant cannot reverse an entry
    Given an accountant
    And a cash sale of 30000
    When the accountant tries to reverse the entry
    Then the response status is 401

  @case:184 @priority:high
  Scenario: The admin entry list rejects an accountant token
    Given an accountant
    When the admin entry list is read with the accountant's token
    Then the response status is 401

  @case:185 @priority:high
  Scenario: The admin overview rejects an accountant token
    Given an accountant
    When the admin overview is read with the accountant's token
    Then the response status is 401

  @case:186 @priority:high
  Scenario: A token that only extends the admin token is rejected
    When the admin overview is read with a token that extends the admin token
    Then the response status is 401

  @case:187 @priority:high
  Scenario: The trial balance requires a token
    When the trial balance is read with no token
    Then the response status is 401

  # ---------------------------------------------------------------- public reference data

  @case:188 @priority:medium
  Scenario: The chart of accounts is public reference data
    When the chart of accounts is read with no token
    Then the response status is 200

  # ---------------------------------------------------------------- positive controls

  @case:189 @priority:high
  Scenario: An accountant may post an entry
    Given an accountant
    When the accountant posts Dr account 1 Cr account 9 for 5000
    Then the entry is posted

  @case:190 @priority:high
  Scenario: The admin may reverse an entry
    Given an accountant
    And a cash sale of 30000
    When the admin reverses the entry
    Then the response status is 201

  @case:191 @priority:medium
  Scenario: Accountant onboarding is open and issues a token
    When an accountant registers
    Then the response status is 201
    And the response carries a token

  # ---------------------------------------------------------------- secret hygiene

  @case:192 @priority:medium
  Scenario: An entry response never carries a bearer token
    Given an accountant
    And a cash sale of 30000
    Then the entry response carries no bearer token

  @case:193 @priority:medium
  Scenario: An account response never carries a bearer token
    When the chart of accounts is read with no token
    Then the accounts response carries no bearer token

  @case:194 @priority:medium
  Scenario: The trial balance never carries a bearer token
    Given an accountant
    When the trial balance is fetched
    Then the report response carries no bearer token

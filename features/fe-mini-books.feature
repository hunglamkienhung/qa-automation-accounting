@module:06-mini-books-fe @fe @books
Feature: The mini-books app surfaces, checked against their own data

  Playwright drives the pages the mini-books service renders -- the chart of
  accounts, an account, a journal entry, and the trial-balance and balance-sheet
  reports. The figures on screen are compared with the rows behind them, read
  through the DB the FE never touches directly, so the FE branch checks the same
  invariants the BE branch does, one layer further out. A page that never loads
  is Blocked, never Failed.

  Background:
    Given the store is open and the service is reachable
    And the home page is open

  # ---------------------------------------------------------------- chart of accounts (home)

  @case:195 @priority:high
  Scenario: The home page lists the seeded chart of accounts
    Then the home page lists at least the sixteen seeded accounts

  @case:196 @priority:medium
  Scenario: Each account row shows a code, a name and a type
    Then every account row shows a code, a name and a type

  @case:197 @priority:medium
  Scenario: Every account balance is a number
    Then every account balance on screen is a number

  @case:198 @priority:medium
  Scenario: The chart of accounts has an account of every type on screen
    Then the home page shows an account of every type

  # ---------------------------------------------------------------- an account

  @case:199 @priority:high
  Scenario: An account page shows the balance from the rows
    Given an accountant
    And a cash sale of 50000
    When the account page for account 1 is opened
    Then the account page balance equals the stored balance

  @case:200 @priority:medium
  Scenario: An account page shows its code and type
    When the account page for account 7 is opened
    Then the account page shows code "3000" and type "equity"

  @case:201 @priority:low
  Scenario: An unknown account page is not found
    When the account page for account 999999 is opened
    Then the page reports not found

  # ---------------------------------------------------------------- a journal entry

  @case:202 @priority:high
  Scenario: An entry page shows a balanced pair of lines
    Given an accountant
    And a cash sale of 30000
    When the entry page is opened
    Then the entry lines on screen show a debit and a credit of the same amount

  @case:203 @priority:medium
  Scenario: An entry page shows its date and status
    Given an accountant
    And a cash sale of 30000
    When the entry page is opened
    Then the entry page shows status "posted"

  @case:204 @priority:medium
  Scenario: A reversed entry page shows it reversed
    Given an accountant
    And a cash sale of 30000
    And the entry is reversed by the admin
    When the entry page is opened
    Then the entry page shows status "reversed"

  @case:205 @priority:low
  Scenario: An unknown entry page is not found
    When the entry page for 999999 is opened
    Then the page reports not found

  # ---------------------------------------------------------------- the trial balance report

  @case:206 @priority:high
  Scenario: The trial balance page shows debits equal to credits
    When the trial balance page is opened
    Then the trial balance page shows the debits equal the credits
    And the trial balance page shows it balanced

  @case:207 @priority:high
  Scenario: The trial balance stays balanced on screen after a posting
    Given an accountant
    And a cash sale of 45000
    When the trial balance page is opened
    Then the trial balance page shows it balanced

  # ---------------------------------------------------------------- the balance sheet report

  @case:208 @priority:high
  Scenario: The balance sheet page balances
    When the balance sheet page is opened
    Then the balance sheet page shows Assets equal Liabilities plus Equity plus Net income
    And the balance sheet page shows it balanced

  @case:209 @priority:high
  Scenario: The balance sheet stays balanced on screen after a purchase on credit
    Given an accountant
    And a balanced entry debiting account 4 and crediting account 5 for 250000
    When the balance sheet page is opened
    Then the balance sheet page shows it balanced

  # ---------------------------------------------------------------- admin

  @case:210 @priority:medium
  Scenario: The admin page shows a balanced set of books
    When the admin page is opened
    Then the admin page shows it balanced

  @case:211 @priority:medium
  Scenario: The admin entry count is a positive integer
    When the admin page is opened
    Then the admin entry count is a positive integer

  # ---------------------------------------------------------------- account balances across the chart

  Scenario Outline: The account page for <acc> shows the stored balance
    Given an accountant
    And a balanced entry debiting account <acc> and crediting account 9 for <amount>
    When the account page for account <acc> is opened
    Then the account page balance equals the stored balance

    @case:212
    Examples:
      | acc | amount |
      | 1 | 12345 |
    @case:213
    Examples:
      | acc | amount |
      | 2 | 40000 |
    @case:214
    Examples:
      | acc | amount |
      | 3 | 33000 |
    @case:215
    Examples:
      | acc | amount |
      | 4 | 88000 |

  Scenario Outline: The account page for <acc> after posting shows the stored balance
    Given an accountant
    And a balanced entry debiting account <acc> and crediting account 10 for <amount>
    When the account page for account <acc> is opened
    Then the account page balance equals the stored balance

    @case:440
    Examples:
      | acc | amount |
      | 1 | 100 |
    @case:441
    Examples:
      | acc | amount |
      | 2 | 999 |
    @case:442
    Examples:
      | acc | amount |
      | 3 | 2500 |
    @case:443
    Examples:
      | acc | amount |
      | 4 | 7777 |
    @case:444
    Examples:
      | acc | amount |
      | 11 | 12345 |
    @case:445
    Examples:
      | acc | amount |
      | 12 | 33333 |
    @case:446
    Examples:
      | acc | amount |
      | 13 | 50000 |
    @case:447
    Examples:
      | acc | amount |
      | 14 | 64000 |
    @case:448
    Examples:
      | acc | amount |
      | 1 | 90909 |
    @case:449
    Examples:
      | acc | amount |
      | 2 | 123456 |
    @case:450
    Examples:
      | acc | amount |
      | 3 | 200000 |
    @case:451
    Examples:
      | acc | amount |
      | 4 | 275000 |
    @case:452
    Examples:
      | acc | amount |
      | 5 | 450000 |
    @case:453
    Examples:
      | acc | amount |
      | 6 | 7 |
    @case:454
    Examples:
      | acc | amount |
      | 7 | 64 |
    @case:455
    Examples:
      | acc | amount |
      | 10 | 8888 |

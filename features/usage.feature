Feature: Using Arlington Ruby Trader

  Given two files `RATES.xml` and `TRANS.csv` respectively:

    1) The first is an XML file containing the conversion rates for exchanging
       one currency with another

    2) The second is a CSV file containing sales data by transaction for an
       international business.

  Running the `arug-trader` will output the grand total of sales for the
  requested item, in the desired currency.

  Scenario: Usage Instructions
    When I run `arug-trader`
    Then the output should contain exactly:
      """
      USAGE: arug-trader ITEM CURRENCY RATES TRANSACTIONS\n
      """

  Scenario: Basic Usage

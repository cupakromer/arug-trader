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
    The provided `RATES.xml` file has a direct mapping of all currencies to each
    other.

    The search criteria is a single `sku` value in one or more of the line items
    in the `TRANS.csv` file.

    Given a file named "RATES.xml" with:
      """xml
      <?xml version="1.0"?>
      <rates>
        <rate>
          <from>CAD</from>
          <to>USD</to>
          <conversion>1.0090</conversion>
        </rate>
        <rate>
          <from>USD</from>
          <to>CAD</to>
          <conversion>0.9911</conversion>
        </rate>
      </rates>
      """
    And a file named "TRANS.csv" with:
      """csv
      store,sku,amount
      Yonkers,DM1210,70.00 USD
      Yonkers,DM1182,19.68 CAD
      Nashua,DM1182,58.58 CAD
      Scranton,DM1210,68.76 USD
      Camden,DM1182,54.64 USD
      """
    When I run `arug-trader DM1182 USD RATES.xml TRANS.csv`
    Then the output should contain exactly "133.60\n"

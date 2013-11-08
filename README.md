# Arug::Trader

[![Build Status](https://secure.travis-ci.org/cupakromer/arug-trader.png?branch=master)](http://travis-ci.org/cupakromer/arug-trader)
[![Dependency Status](https://gemnasium.com/cupakromer/arug-trader.png?travis)](https://gemnasium.com/cupakromer/arug-trader)
[![Code Climate](https://codeclimate.com/github/cupakromer/arug-trader.png)](https://codeclimate.com/github/cupakromer/arug-trader)
[![Coverage Status](https://coveralls.io/repos/cupakromer/arug-trader/badge.png)](https://coveralls.io/r/cupakromer/arug-trader)
[![Stories in Ready](https://badge.waffle.io/scrappyacademy/arug-trader.png)](http://waffle.io/scrappyacademy/arug-trader)

Coder Night #1 Problem: [[#1] International trade](http://www.puzzlenode.com/puzzles/1-international-trade)

## Problem

You have been given two files. The first is an XML file containing the
conversion rates for exchanging one currency with another. The second is a CSV
file containing sales data by transaction for an international business. Your
goal is to parse all the transactions and return the grand total of all sales
for a given item.

What is the grand total of sales for item `DM1182` across all stores in `USD`
currency?

### Notes

 - After each conversion, the result should be rounded to 2 decimal places
   using <a href="http://en.wikipedia.org/wiki/Rounding#Round_half_to_even">bankers rounding</a>.
 - Some conversion rates are missing; you will need to derive them using the
   information provided.
 - Since we are working with financial transactions, we need to avoid floating
   point arithmetic errors.

### Example

Given a `RATES.xml` of:

```xml
<?xml version="1.0"?>
<rates>
  <rate>
    <from>AUD</from>
    <to>CAD</to>
    <conversion>1.0079</conversion>
  </rate>
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
```

and a `TRANS.csv` of:

```text
store,sku,amount
Yonkers,DM1210,70.00 USD
Yonkers,DM1182,19.68 AUD
Nashua,DM1182,58.58 AUD
Scranton,DM1210,68.76 USD
Camden,DM1182,54.64 USD
```

Your program should return `134.22` as the total of `DM1182` in `USD`. You can
use the sample files from this example to test your program before submitting
an answer for the real dataset for this problem.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'arug-trader'
```

And then execute:

```shell
$ bundle
```

Or install it yourself as:

```shell
$ gem install arug-trader
```

## Usage

Given input file `RATES.xml` and `TRANS.csv` the program can be run requesting
the grand total of sales for item `DM1182` across all stores in `USD` with:

```shell
$ arug-trader DM1182 USD RATES.xml TRANS.csv
134.22
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


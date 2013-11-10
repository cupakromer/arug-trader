require 'spec_helper'
require 'arug/trader/rates_file'

module Arug
  module Trader
    describe RatesFile do

      #read(pathname)
      #returns array of exchange rates
      context "with no rates" do
        it "reading the file returns an empty array" do
          with_temp_file("no_rates.xml", <<EOF) do |file_path|
<?xml version="1.0"?>
<rates>
</rates>
EOF
            file = RatesFile.new(file_path)

            expect(file.read).to eq []
          end
        end
      end

      context "with rates" do
        it "reading the file returns an array of exchange rates" do
          with_temp_file("rates.xml", <<EOF) do |file_path|
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
EOF
            file = RatesFile.new(file_path)

            expect(file.read).to eq [
              OpenStruct.new(
                from: 'AUD',
                to:   'CAD',
                rate: BigDecimal.new('1.0079')
              ),
              OpenStruct.new(
                from: 'CAD',
                to:   'USD',
                rate: BigDecimal.new('1.0090')
              ),
              OpenStruct.new(
                from: 'USD',
                to:   'CAD',
                rate: BigDecimal.new('0.9911')
              ),
            ]
          end
        end

        it "the exchange rates are frozen" do
          with_temp_file("rates.xml", <<EOF) do |file_path|
<?xml version="1.0"?>
<rates>
  <rate>
    <from>AUD</from>
    <to>CAD</to>
    <conversion>1.0079</conversion>
  </rate>
</rates>
EOF
            rate = RatesFile.new(file_path).read.first

            expect{ rate.from = 'USD' }.to raise_error TypeError,
              "can't modify frozen OpenStruct"
          end
        end
      end

    end
  end
end

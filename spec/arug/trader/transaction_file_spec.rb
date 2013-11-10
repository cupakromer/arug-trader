require 'spec_helper'
require 'arug/trader/transaction_file'

module Arug
  module Trader
    describe TransactionFile do

      context "with no line items" do
        it "reading the file returns an empty array" do
          with_temp_file("no_line_items.csv", "store,sku,amount") do |file_path|
            file = TransactionFile.new(file_path)

            expect(file.read).to eq []
          end
        end
      end

      context "with line items" do
        it "reading the file returns a list of line items" do
          with_temp_file("line_items.csv", <<EOF) do |file_path|
store,sku,amount
Yonkers,DM1210,70.00 USD
Yonkers,DM1182,19.68 AUD
Nashua,DM1182,58.58 AUD
EOF

            file = TransactionFile.new(file_path)

            expect(file.read).to match_array [
              LineItem.new(
                store: "Yonkers",
                sku: "DM1210",
                amount: Money.new(70.00, "USD")
              ),
              LineItem.new(
                store: "Yonkers",
                sku: "DM1182",
                amount: Money.new(19.68, "AUD")
              ),
              LineItem.new(
                store: "Nashua",
                sku: "DM1182",
                amount: Money.new(58.58, "AUD")
              ),
            ]
          end
        end
      end

    end
  end
end

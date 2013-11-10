require 'spec_helper'
require 'arug/trader/line_item'

module Arug
  module Trader
    describe LineItem do

      it "requires an amount" do
        expect{ LineItem.new(store: "Acme Inc.") }
          .to raise_error ArgumentError, "Missing amount"
      end

      it "requires at least one other field" do
        expect{ LineItem.new(amount: "1.01 USD") }
          .to raise_error ArgumentError, "Missing a context field"
      end

      it "has an amount" do
        expected_amount = Money.new(1.01, "USD")
        line = LineItem.new(store: "Acme, Inc.", amount: "1.01 USD")

        expect(line.amount).to eq expected_amount
      end

      it "delegates currency to the amount" do
        amount = Money.new(1.01, "USD")
        expect(amount).to receive(:currency).and_return("USD")

        line = LineItem.new(store: "Acme, Inc.", amount: amount)

        expect(line.currency).to eq "USD"
      end

      it "allows Money as an amount" do
        expected_amount = Money.new(1.01, "USD")
        line = LineItem.new(store: "Acme, Inc.", amount: expected_amount)

        expect(line.amount).to eq expected_amount
      end

      context "with multiple fields" do
        it "has an reader for each field" do
          fields = {
            store: "Acme, Inc.",
            sku: "DM1123A",
            color: :red,
          }

          line = LineItem.new(fields.merge(amount: "1.01 USD"))

          fields.each_pair do |field, expected_value|
            expect(line.public_send(field)).to eq expected_value
          end
        end

        context "enumerating over each" do
          it "yields each field name and value" do
            fields = {
              sku: "DM1123A",
              color: :red,
              amount: Money.new(1.01, "USD"),
            }

            line = LineItem.new(fields.merge(amount: "1.01 USD"))

            expect{ |b| line.each(&b) }.to yield_successive_args(
              [:sku, "DM1123A"],
              [:color, :red],
              [:amount, Money.new(1.01, "USD")]
            )
          end
        end

        context "enumerating over each pair" do
          it "yields each field name and value" do
            fields = {
              sku: "DM1123A",
              color: :red,
              amount: Money.new(1.01, "USD"),
            }

            line = LineItem.new(fields.merge(amount: "1.01 USD"))

            expect{ |b| line.each_pair(&b) }.to yield_successive_args(
              [:sku, "DM1123A"],
              [:color, :red],
              [:amount, Money.new(1.01, "USD")]
            )
          end
        end

        context "inspecting the line item" do
          subject(:line) {
            LineItem.new(sku: "DM1123A", color: :red, amount: "1.01 USD")
          }

          it "shows the class" do
            expect(line.inspect).to start_with "#<Arug::Trader::LineItem"
          end

          it "shows the memory location as hex" do
            memory_hex = "%08x" % (line.object_id << 1)

            expect(line.inspect).to match /:0x#{memory_hex}/
          end

          it "lists each field pair" do
            amount = line.amount

            expect(line.inspect).to end_with \
              "sku: \"DM1123A\", color: :red, amount: #{amount.inspect}>"
          end
        end

        context "checking if it matches a criteria hash" do
          subject(:line) {
            LineItem.new(sku: "DM1123A", color: :red, amount: "1.01 USD")
          }

          it "matches if the criteria are empty" do
            expect(line.matches?({})).to be true
          end

          it "matches when all criteria are met" do
            expect(line.matches?(sku: "DM1123A", color: :red)).to be true
          end

          it "does not match otherwise" do
            expect(line.matches?(color: 'red')).to be false
          end

          it "normalizes the field names" do
            expect(line.matches?("COlor" => :red)).to be true
          end
        end
        context "converting the line item to a hash" do
          it "maps field names, as downcased symbol keys, to the values" do
            amount = Money.new(1.01, 'USD')

            line = LineItem.new(
              "SToRe"  => "Acme, Inc.",
              :sku     => "DM1123A",
              'amount' => amount
            )

            expect(line.to_h).to eq({
              store:  "Acme, Inc.",
              sku:    "DM1123A",
              amount: amount
            })
          end
        end
      end

      context "given two line items with the same fields" do
        subject(:lineA) { LineItem.new(fields) }

        let(:lineB) { LineItem.new(fields) }
        let(:fields) {
          {
            store: "Acme, Inc.",
            sku: "DM1123A",
            amount: "1.01 USD",
          }
        }

        it "they are equal" do
          expect(lineA).to eq lineB
        end

        it "they are exactly equal" do
          expect(lineA).to eql lineB
        end

        it "they have the same hash code" do
          expect(lineA.hash).to eq lineB.hash
        end
      end

      context "given two line items differing by a field value" do
        subject(:lineA) {
          LineItem.new(store: "Store A", sku: "DM1", amount: "1.01 USD")
        }

        let(:lineB) {
          LineItem.new(store: "Store B", sku: "DM1", amount: "1.01 USD")
        }

        it "they are not equal" do
          expect(lineA).not_to eq lineB
        end

        it "they are not exactly equal" do
          expect(lineA).not_to eql lineB
        end

        it "they do not have the same hash code" do
          expect(lineA.hash).not_to eq lineB.hash
        end
      end

      context "given two line items differing by a field name" do
        subject(:lineA) {
          LineItem.new(store: "Store A", sku: "DM1", amount: "1.01 USD")
        }

        let(:lineB) {
          LineItem.new(place: "Store A", sku: "DM1", amount: "1.01 USD")
        }

        it "they are not equal" do
          expect(lineA).not_to eq lineB
        end

        it "they are not exactly equal" do
          expect(lineA).not_to eql lineB
        end

        it "they do not have the same hash code" do
          expect(lineA.hash).not_to eq lineB.hash
        end
      end

      context "given two line items where a field name and value are swapped" do
        subject(:lineA) { LineItem.new(sku: :dm, amount: "1.01 USD") }

        let(:lineB) { LineItem.new(dm: :sku, amount: "1.01 USD") }

        it "they are not equal" do
          expect(lineA).not_to eq lineB
        end

        it "they are not exactly equal" do
          expect(lineA).not_to eql lineB
        end

        it "they do not have the same hash code" do
          pending "NOT SURE HOW TO TWEAK THE HASH FUNC FOR THIS CASE"
          expect(lineA.hash).not_to eq lineB.hash
        end
      end

      context "comparing to another object which responds to pairs" do
        subject(:line) { LineItem.new(sku: "DM1", amount: "1.01 USD") }

        let(:duck) {
          double('Wack', pairs: { sku: "DM1", amount: Money.new(1.01, "USD") })
        }

        it "they are equal" do
          expect(line).to eq duck
        end

        it "they are not exactly equal" do
          expect(line).not_to eql duck
        end

        it "they do not have the same hash code" do
          expect(line.hash).not_to eq duck.hash
        end
      end

      context "comparing to another object that doesn't respond to pairs" do
        subject(:line) { LineItem.new(sku: "DM1", amount: "1.01 USD") }

        it "they are not equal" do
          expect(line).not_to eq({sku: "DM1", amount: Money.new(1.01, "USD")})
        end

        it "they are not exactly equal" do
          expect(line).not_to eql({sku: "DM1", amount: Money.new(1.01, "USD")})
        end
      end

    end
  end
end

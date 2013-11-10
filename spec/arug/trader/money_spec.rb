require 'spec_helper'
require 'arug/trader/money'

module Arug
  module Trader
    describe Money do

      subject(:money) { Money.new(42.55, 'USD') }

      context "creating Money" do
        it "accepts string amounts" do
          expected_amount = BigDecimal.new("42.55")

          expect(Money.new('42.55', 'USD').amount).to eq expected_amount
        end

        it "accepts decimal amounts" do
          expected_amount = BigDecimal.new("42.55")

          expect(Money.new(42.55, 'USD').amount).to eq expected_amount
        end

        it "stores the currency in upper case" do
          expect(Money.new(1, 'usd').currency).to eq 'USD'
        end
      end

      it "is represented as a string by it's amount and currency" do
        expect(money.to_s).to eq "42.55 USD"
      end

      context "given two monies with equal amounts and the same currency" do
        subject(:moneyA) { Money.new(11.23, "USD") }

        let(:moneyB) { Money.new(11.23, "USD") }

        it "they are equal" do
          expect(moneyA).to eq moneyB
        end

        it "they are exactly equal" do
          expect(moneyA).to eql moneyB
        end

        it "have the same hash code" do
          expect(moneyA.hash).to eq moneyB.hash
        end
      end

      shared_examples "are considered different" do
        it "they are not equal" do
          expect(moneyA).not_to eq moneyB
        end

        it "they are not exactly equal" do
          expect(moneyA).not_to eq moneyB
        end

        it "they have different hash codes" do
          expect(moneyA.hash).not_to eq moneyB.hash
        end
      end

      context "given two monies with different amounts and the same currency" do
        subject(:moneyA) { Money.new(11.23, "USD") }

        let(:moneyB) { Money.new(11.22, "USD") }

        has_behavior "are considered different"
      end

      context "given two monies with the same amounts and different currency" do
        subject(:moneyA) { Money.new(11.23, "USD") }

        let(:moneyB) { Money.new(11.23, "EUR") }

        has_behavior "are considered different"
      end

      context "given a money and another object acting like a money" do
        subject(:moneyA) { Money.new(11.23, "USD") }

        let(:moneyB) {
          double(Money, amount: BigDecimal.new("11.23"), currency: "USD")
        }

        has_behavior "are considered different"
      end

      context "given a money and another object" do
        it "they are not equal" do
          m1 = Money.new(11.23, "USD")

          expect(m1).not_to eq 5
        end
      end

    end
  end
end

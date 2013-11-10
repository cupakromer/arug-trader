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

      it "is represented as a float by the amount as a float" do
        expect(Money.new(1.01, 'USD').to_f).to eq 1.01
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

      it "can be multiplied by a number" do
        m1 = Money.new(1.01, "USD")

        expect(m1 * 2).to eq Money.new(2.02, "USD")
      end

      it "can be multiplied by a decimal" do
        m1 = Money.new(1.01, "USD")

        expect(m1 * 2.01).to eq Money.new(2.0301, "USD")
      end

      it "can be divided by a number" do
        m1 = Money.new(1.00, "USD")

        expect(m1 / 4).to eq Money.new(0.25, "USD")
      end

      it "can be divided by a decimal" do
        m1 = Money.new(5.25, "USD")

        expect(m1 / 2.1).to eq Money.new(2.50, "USD")
      end

      context "given two monies with the same currency" do
        subject(:moneyA) { Money.new(1.11, 'USD') }

        let(:moneyB) { Money.new(1.01, 'USD') }

        it "they can be added" do
          expect(moneyA + moneyB).to eq Money.new(2.12, 'USD')
        end

        it "they can be subtracted" do
          expect(moneyA - moneyB).to eq Money.new(0.10, 'USD')
        end

        it "they cannot be multiplied" do
          expect{ moneyA * moneyB }.to raise_error "Cannot multiply by money"
        end

        it "they cannot be divided" do
          expect{ moneyA / moneyB }.to raise_error "Cannot divide by money"
        end
      end

      context "given two monies with different currencies" do
        subject(:moneyA) { Money.new(1.11, 'USD') }

        let(:moneyB) { Money.new(1.01, 'EUR') }

        it "they cannot be added" do
          expect{ moneyA + moneyB }.to raise_error "Currency mismatch"
        end

        it "they cannot be subtracted" do
          expect{ moneyA - moneyB }.to raise_error "Currency mismatch"
        end

        it "they cannot be multiplied" do
          expect{ moneyA * moneyB }.to raise_error "Cannot multiply by money"
        end

        it "they cannot be divided" do
          expect{ moneyA / moneyB }.to raise_error "Cannot divide by money"
        end
      end

    end
  end
end

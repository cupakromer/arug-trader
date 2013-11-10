require 'spec_helper'
require 'arug/trader/exchange'
require 'ostruct'

module Arug
  module Trader
    describe Exchange do

      def conversion(from, to, rate)
        OpenStruct.new(from: from, to: to, rate: rate)
      end

      context "creating an exchange" do
        it "can take a single rate" do
          expect{ Exchange.new(double('Rate')) }.not_to raise_error
        end

        it "can take multiple rates" do
          expect{ Exchange.new([double('Rate')] * 3) }.not_to raise_error
        end
      end

      context "converting money from the same currency to itself" do
        it "returns the same amount" do
          exchange = Exchange.new(double('Rate'))

          money = Money.new(1.01, 'USD')

          expect(exchange.convert(money, 'USD')).to eq money
        end
      end

      context "given a direct conversion" do
        subject(:exchange) { Exchange.new(:ignored_rates, mapper_class) }

        let(:mapper_class) { double('NoConversions', new: mapper) }
        let(:mapper) { double('NoConversions', path: [rate]).as_null_object }
        let(:rate) { conversion('CAD', 'USD', 0.8870) }

        it "returns new money in the desired currency" do
          money = Money.new(1.20, 'CAD')

          expect(exchange.convert(money, 'USD').currency).to eq 'USD'
        end

        it "delegates finding the conversion to the mapper" do
          money = Money.new(1.20, 'CAD')

          expect(mapper).to receive(:path)
            .with(from: 'CAD', to: 'YEN')
            .and_return([rate])

          exchange.convert(money, 'YEN')
        end

        it "returns new money rounded to two decimals using bankers rounding" do
          money = Money.new(1.20, 'CAD')

          expect(exchange.convert(money, 'USD').amount).to eq BigDecimal('1.06')
        end
      end

      context "given an indirect conversion" do
        subject(:exchange) { Exchange.new(:ignored_rates, mapper_class) }

        let(:mapper_class) { double('NoConversions', new: mapper) }
        let(:mapper) { double('NoConversions', path: rates).as_null_object }
        let(:rates) {
          # These rates were specially chosen to meet all 4 banker rounding
          # rules based on a starting value of 1.20
          [
            conversion('CAD', 'USD', 1.0125),   # Exactly 0.5 with odd
            conversion('USD', 'YEN', 1.0286),   # Below 0.5
            conversion('YEN', 'EUR', 1.0120),   # Exactly 0.5 with even
            conversion('EUR', 'AUD', 0.9405),   # Above 0.5
          ]
        }

        it "returns new money in the desired currency" do
          money = Money.new(1.20, 'CAD')

          expect(exchange.convert(money, 'AUD').currency).to eq 'AUD'
        end

        it "delegates finding the conversion to the mapper" do
          money = Money.new(1.20, 'CAD')

          expect(mapper).to receive(:path)
            .with(from: 'CAD', to: 'AUD')
            .and_return(rates)

          exchange.convert(money, 'AUD')
        end

        it "returns new money rounded to two decimals using bankers rounding" do
          money = Money.new(1.20, 'CAD')

          expect(exchange.convert(money, 'AUD').amount).to eq BigDecimal('1.19')
        end
      end

      context "given no conversion" do
        subject(:exchange) { Exchange.new(:ignored_rates, mapper_class) }

        let(:mapper_class) { double('NoConversions', new: mapper) }
        let(:mapper) { double('NoConversions', path: []).as_null_object }

        context "converting from any money to another" do
          it "delegates finding the conversion to the mapper" do
            money = Money.new(1.20, 'CAD')

            expect(mapper).to receive(:path)
              .with(from: 'CAD', to: 'YEN')
              .and_return([])

            expect{ exchange.convert(money, 'YEN') }.to raise_error
          end

          it "raises an UnknownExchange error" do
            money = Money.new(1.20, 'CAD')

            expect{ exchange.convert(money, 'YEN') }
              .to raise_error UnknownExchange, "'CAD' -> 'YEN'"
          end
        end
      end

    end
  end
end

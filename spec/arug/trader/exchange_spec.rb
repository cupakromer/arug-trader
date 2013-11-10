require 'spec_helper'
require 'arug/trader/exchange'
require 'ostruct'

module Arug
  module Trader
    describe Exchange do

      def create_conversion(from, to, rate)
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
        subject(:exchange) {
          Exchange.new([
            create_conversion('CAD', 'EUR', 9.9999),
            create_conversion('CAD', 'USD', 0.8870)
          ])
        }

        it "returns new money in the desired currency" do
          money = Money.new(1.20, 'CAD')

          expect(exchange.convert(money, 'USD')).to eq Money.new(1.06, 'USD')
        end
      end

    end
  end
end

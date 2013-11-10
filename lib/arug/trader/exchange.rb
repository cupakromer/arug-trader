require 'arug/trader/money'

module Arug
  module Trader
    class Exchange
      def initialize(rates)
        @rates = Array(rates)
      end

      def convert(money, currency)
        return money.dup if money.currency == currency

        rate = rates.find{ |r| r.from == money.currency && r.to == currency }

        new_amount = (money.amount * rate.rate).round(2, :banker)

        Money.new(new_amount, currency)
      end

      private
      attr_reader :rates
    end
  end
end

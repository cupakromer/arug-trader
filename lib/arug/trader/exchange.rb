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

        base = Money.new(money.amount, currency)

        (base * rate.rate).round(2, :banker)
      end

      private
      attr_reader :rates
    end
  end
end

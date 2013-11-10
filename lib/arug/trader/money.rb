require 'bigdecimal'

module Arug
  module Trader
    class Money
      attr_reader :amount, :currency

      def initialize(amount, currency)
        @amount = BigDecimal.new(amount.to_s)
        @currency = currency.upcase
      end

      def ==(other)
        self.class === other &&
          amount == other.amount &&
          currency == other.currency
      end
      alias_method :eql?, :==

      def hash
        amount.hash ^ currency.hash
      end

      def to_s
        "#{amount.to_s(?F)} #{currency}"
      end
    end
  end
end

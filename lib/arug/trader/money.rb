require 'bigdecimal'

module Arug
  module Trader
    class Money
      attr_reader :amount, :currency

      def initialize(amount, currency)
        @amount = BigDecimal.new(amount.to_s)
        @currency = currency.upcase
      end

      def +(other)
        raise ArgumentError, "Currency mismatch" unless currency_match? other

        self.class.new(amount + other.amount, currency)
      end

      def -(other)
        raise ArgumentError, "Currency mismatch" unless currency_match? other

        self.class.new(amount - other.amount, currency)
      end

      def *(num)
        raise ArgumentError, "Cannot multiply by money" if self.class === num

        Money.new(amount * num, currency)
      end

      def /(num)
        raise ArgumentError, "Cannot divide by money" if self.class === num

        Money.new(amount / num, currency)
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

      def round(n = 2, mode = :banker)
        Money.new(amount.round(n, mode), currency)
      end

      def to_f
        amount.to_f
      end

      def to_s
        "#{amount.to_s(?F)} #{currency}"
      end

      private
      def currency_match?(other)
        self.class === other && currency == other.currency
      end
    end
  end
end

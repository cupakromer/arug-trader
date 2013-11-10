module Arug
  module Trader
    class Ledger
      def initialize(line_items, exchange)
        @line_items = line_items
        @exchange = exchange
      end

      def sum(currency, criteria = {})
        total = Money.new(0, currency)

        matching_line_items = line_items.select{ |i| i.matches? criteria }

        currency_sums(matching_line_items).reduce(total){ |total, subsum|
          total + exchange.convert(subsum, currency)
        }
      end

      private
      attr_reader :line_items, :exchange

      def currency_sums(items)
        items.map(&:amount)
             .group_by(&:currency)
             .map{ |c, amounts| amounts.reduce(Money.new(0, c), :+) }
      end
    end
  end
end

require 'arug/trader/best_conversion'
require 'arug/trader/money'

module Arug
  module Trader
    UnknownExchange = Class.new(RuntimeError)

    class Exchange
      def initialize(rates, rate_mapper = BestConversion)
        @rate_mapper = rate_mapper.new(Array(rates))
      end

      def convert(money, currency)
        source, target = money.currency, currency

        return money if source == target

        rates = rate_mapper.path(from: source, to: target)

        if rates.empty?
          raise UnknownExchange, "'#{source}' -> '#{target}'"
        else
          rates.inject(Money.new(money.amount, target)){ |converted, rate|
            (converted * rate.rate).round(2, :banker)
          }
        end
      end

      private
      attr_reader :rate_mapper
    end
  end
end

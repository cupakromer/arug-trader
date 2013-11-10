require 'arug/trader/money'

module Arug
  module Trader
    class LineItem
      attr_reader :pairs
      protected :pairs

      def initialize(data)
        @pairs = Hash[ data.each_pair.map{ |k, v| [k.downcase.to_sym, v] } ]

        normalize_amount!

        raise ArgumentError.new("Missing a context field") unless @pairs.count > 1

        add_attr_readers!
      end

      def ==(other)
        other.respond_to?(:pairs, true) ?  pairs == other.pairs : false
      end

      def each(&block)
        pairs.each(&block)
      end
      alias_method :each_pair, :each

      def eql?(other)
        self.class === other && self == other
      end

      def hash
        pairs.reduce(0){ |code, (k, v)| code ^ k.hash ^ v.hash }
      end

      def inspect
        pair_list = pairs.map{ |k, v| "#{k}: #{v.inspect}" }.join(", ")

        "#<#{self.class}:0x%08x #{pair_list}>" % (object_id << 1)
      end

      def to_h
        pairs.dup
      end

      private
      def add_attr_readers!
        singleton_class.instance_exec(pairs.keys) do |attrs|
          attrs.each do |attr|
            define_method(attr){ @pairs[attr] }
          end
        end
      end

      def normalize_amount!
        raise ArgumentError.new("Missing amount") unless pairs[:amount]
        return if pairs[:amount].is_a? Money

        amount, currency = pairs[:amount].split
        pairs[:amount] = Money.new(amount, currency)
      end
    end
  end
end

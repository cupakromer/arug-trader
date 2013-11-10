require 'arug/core_ext/enumerable'

module Arug
  module Trader
    class BestConversion
      def initialize(rates)
        @rates = Array(rates)
      end

      def path(from: nil, to: nil)
        raise ArgumentError, "Missing currency" unless from && to

        traverse(rates, from, to)
      end

      private
      attr_reader :rates

      def traverse(paths, here, destination)
        return [] if paths.empty?

        choices, remainder = split(paths, here)

        if last_leg = choices.find{ |r| r.to == destination }
          [last_leg]
        else
          choices.find_map([]){ |choice|
            path = traverse(remainder, choice.to, destination)
            path.unshift(choice) unless path.empty?
          }
        end
      end

      def split(edges, matching)
        direct_paths = edges.select{ |r| r.from == matching }
        remainder = edges - direct_paths

        [direct_paths, remainder]
      end
    end
  end
end

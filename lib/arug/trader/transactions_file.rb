require 'arug/core_ext/csv'
require 'arug/trader/line_item'
require 'pathname'

module Arug
  module Trader
    class TransactionsFile
      def self.read(file_path)
        new(file_path).read
      end

      def initialize(file_path)
        @csv_opts = { headers: true, header_converters: %i{ downcase symbol } }
        @pathname = Pathname.new(file_path)
      end

      def read
        line_items = CSV.read(pathname, csv_opts)
                        .map{ |t| Arug::Trader::LineItem.new(t) }
      end

      private
      attr_reader :csv_opts, :pathname
    end
  end
end

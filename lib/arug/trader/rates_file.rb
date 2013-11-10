require 'bigdecimal'
require 'ostruct'
require 'pathname'
require 'rexml/document'

module Arug
  module Trader
    class RatesFile
      def self.read(file_path)
        new(file_path).read
      end

      def initialize(file_path)
        @pathname = Pathname.new(file_path)
      end

      def read
        doc = REXML::Document.new(File.new(pathname))

        doc.elements.inject("rates/rate", []) do |rates, rate|
          rates << OpenStruct.new(parse(rate)).freeze
        end
      end

      private
      attr_reader :pathname

      def parse(rate)
        elements = rate.elements

        {
          from: elements["from"].text,
          to:   elements["to"].text,
          rate: BigDecimal.new(elements["conversion"].text),
        }
      end
    end
  end
end

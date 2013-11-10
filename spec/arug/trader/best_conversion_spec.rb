require 'spec_helper'
require 'arug/trader/best_conversion'
require 'bigdecimal'
require 'ostruct'

module Arug
  module Trader
    describe BestConversion do

      def conversion(from, to, rate)
        OpenStruct.new(from: from, to: to, rate: BigDecimal.new(rate.to_s))
      end

      subject(:mapper) { BestConversion.new(rates) }

      let(:rates) { [] }

      context "requesting a path from one currency to another" do
        it "raises are error if no original currency is provided" do
          expect{ mapper.path(to: 'USD') }.to raise_error ArgumentError
        end

        it "raises are error if no desired currency is provided" do
          expect{ mapper.path(from: 'USD') }.to raise_error ArgumentError
        end
      end

      context "given no rates" do
        let(:rates) { [] }

        context "requesting a path from one currency to another" do
          it "returns an empty array" do
            expect(mapper.path(from: 'USD', to: 'YEN')).to eq []
          end
        end
      end

      context "given no rate path" do
        let(:rates) {
          [
            conversion('USD', 'YEN', 1.01),
            conversion('YEN', 'AUD', 1.01),
          ]
        }

        context "requesting a path from one currency to another" do
          it "returns an empty array" do
            expect(mapper.path(from: 'USD', to: 'CAD')).to eq []
          end
        end
      end

      context "given a direct rate path" do
        let(:rates) { [conversion('USD', 'YEN', 1.01)] }

        context "requesting a path from one currency to another" do
          it "returns the direct path" do
            expect(mapper.path(from: 'USD', to: 'YEN')).to eq [
              conversion('USD', 'YEN', 1.01)
            ]
          end
        end
      end

      context "given an indirect rate path" do
        let(:rates) {
          [
            conversion('YEN', 'CAD', 1.01),
            conversion('USD', 'YEN', 2.01),
            conversion('CAD', 'AUD', 3.01),
          ]
        }

        context "requesting a path from one currency to another" do
          it "returns the indirect path" do
            expect(mapper.path(from: 'USD', to: 'AUD')).to eq [
              conversion('USD', 'YEN', 2.01),
              conversion('YEN', 'CAD', 1.01),
              conversion('CAD', 'AUD', 3.01),
            ]
          end
        end
      end

      context "given an indirect rate path and a direct rate path" do
        let(:rates) {
          [
            conversion('YEN', 'CAD', 1.01),
            conversion('USD', 'YEN', 2.01),
            conversion('CAD', 'AUD', 3.01),
            conversion('USD', 'AUD', 2.02),
          ]
        }

        context "requesting a path from one currency to another" do
          it "returns the direct rate path" do
            expect(mapper.path(from: 'USD', to: 'AUD')).to eq [
              conversion('USD', 'AUD', 2.02),
            ]
          end
        end
      end

      context "given two indirect rate paths" do
        let(:rates) {
          [
            conversion('YEN', 'CAD', 1.01),
            conversion('USD', 'YEN', 2.01),
            conversion('CAD', 'AUD', 3.01),
            conversion('USD', 'CAD', 2.02),
          ]
        }

        context "requesting a path from one currency to another" do
          it "returns the indirect path with the best guessed rate" do
            pending
            expect(mapper.path(from: 'USD', to: 'AUD')).to eq [
              conversion('USD', 'YEN', 2.01),
              conversion('YEN', 'CAD', 1.01),
              conversion('CAD', 'AUD', 3.01),
            ]
          end
        end
      end

    end
  end
end

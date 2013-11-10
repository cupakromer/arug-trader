require 'spec_helper'
require 'arug/core_ext/enumerable'

describe Enumerable do

  context "finding the first mapped value" do
    subject(:enum)  { [1, 2, 3] }

    it "yields each entry to the block" do
      yielded = []

      expect{ enum.find_map{ |i| yielded << i; nil } }.to change{ yielded }
        .to [1, 2, 3]
    end

    it "returns the first block value which is truthy" do
      expect(enum.find_map{ |i| :yep if i == 2 }).to be :yep
    end

    context "no block returns a truthy value" do
      it "returns ifnone if specific" do
        expect(enum.find_map(:fail){ |i| :yep if i == 4 }).to be :fail
      end

      it "returns nil otherwise" do
        expect(enum.find_map{ |i| :yep if i == 4 }).to be nil
      end
    end

    it "returns an enumerator when no block is provided" do
      expect([].find_map).to be_a Enumerator
    end
  end

end

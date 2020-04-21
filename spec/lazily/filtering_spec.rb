require "spec_helper"

describe Lazily, "filter" do

  describe "#collect" do

    it "transforms items" do
      expect([1,2,3].lazily.collect { |x| x * 2 }.to_a).to eq([2,4,6])
    end

    it "is lazy" do
      expect([1,2,3].ecetera.lazily.collect { |x| x * 2 }).to be_lazy
    end

  end

  describe "#select" do

    it "excludes items that don't pass the predicate" do
      expect((1..6).lazily.select { |x| x%2 == 0 }.to_a).to eq([2,4,6])
    end

    it "is lazy" do
      expect((1..6).ecetera.lazily.select { |x| x%2 == 0 }).to be_lazy
    end

  end

  describe "#reject" do

    it "excludes items that do pass the predicate" do
      expect((1..6).lazily.reject { |x| x%2 == 0 }.to_a).to eq([1,3,5])
    end

    it "is lazy" do
      expect((1..6).ecetera.lazily.reject { |x| x%2 == 0 }).to be_lazy
    end

  end

  describe "#uniq" do

    it "removes duplicates" do
      expect([1,3,2,4,3,5,4,6].lazily.uniq.to_a).to eq([1,3,2,4,5,6])
    end

    it "is lazy" do
      expect([1,2,3].ecetera.lazily.uniq).to be_lazy
    end

    context "with a block" do

      it "uses the block to derive identity" do
        array = %w(A1 A2 B1 A3 C1 B2 C2)
        expect(array.lazily.uniq { |s| s[0,1] }.to_a).to eq(%w(A1 B1 C1))
      end

    end

  end

  describe "#take" do

    it "includes the specified number" do
      array = [1,2,3,4]
      expect(array.lazily.take(3).to_a).to eq([1,2,3])
    end

    it "is lazy" do
      expect([1,2].ecetera.lazily.take(2)).to be_lazy
    end

    it "copes with 0" do
      expect([].ecetera.lazily.take(0).to_a).to eq([])
    end

  end

  describe "#take_while" do

    it "takees elements as long as the predicate is true" do
      array = [2,4,6,3]
      expect(array.lazily.take_while(&:even?).to_a).to eq([2,4,6])
    end

    it "is lazy" do
      expect([2,3].ecetera.lazily.take_while(&:even?)).to be_lazy
    end

  end

  describe "#drop" do

    it "excludes the specified number" do
      array = [1,2,3,4]
      expect(array.lazily.drop(2).to_a).to eq([3,4])
    end

    it "is lazy" do
      expect([1,2,3,4].ecetera.lazily.drop(2).lazily.take(1).to_a).to eq([3])
    end

  end

  describe "#drop_while" do

    it "drops elements as long as the predicate is true" do
      array = [2,4,6,3,4]
      expect(array.lazily.drop_while(&:even?).to_a).to eq([3,4])
    end

    it "is lazy" do
      expect([2,3].ecetera.lazily.drop_while(&:even?).lazily).to be_lazy
    end

  end

  describe "#grep" do

    let(:fruits) { %w(apple banana pear orange) }

    it "returns elements matching a pattern" do
      expect(fruits.lazily.grep(/e$/).to_a).to eq(%w(apple orange))
    end

    it "applies the associated block" do
      expect(fruits.lazily.grep(/e$/, &:capitalize).to_a).to eq(%w(Apple Orange))
    end

    it "is lazy" do
      expect(fruits.ecetera.lazily.grep(/p/)).to be_lazy
    end

  end

  describe "#flatten" do

    let(:array1) { [1,2,3] }
    let(:array2) { [4,5,6] }

    it "flattens" do
      expect([[1,2], [3,4]].lazily.flatten.to_a).to eq([1,2,3,4])
    end

    it "handles non-Enumerable elements" do
      expect([1,2].lazily.flatten.to_a).to eq([1,2])
    end

    it "goes one level deep (by default)" do
      expect([[1,2], [[3]]].lazily.flatten.to_a).to eq([1,2,[3]])
    end

    it "allows the depth to be specified" do
      expect([[1], [[2]], [[[3]]]].lazily.flatten(2).to_a).to eq([1, 2, [3]])
    end

    it "is lazy" do
      expect([array1.ecetera, array2].lazily.flatten).to be_lazy
    end

  end

  describe "#flat_map" do

    let(:array) { [1,2,3] }

    it "flattens resulting Enumerables" do
      expect(array.lazily.flat_map { |n| [n] * n }.to_a).to eq([1,2,2,3,3,3])
    end

    it "handles blocks that don't return Enumerables" do
      expect(array.lazily.flat_map { |n| n * n }.to_a).to eq([1,4,9])
    end

    it "handles nils " do
      expect(array.lazily.flat_map { nil }.to_a).to eq([nil, nil, nil])
    end

    it "is lazy" do
      expect(array.ecetera.lazily.flat_map { |n| [n] * n }).to be_lazy
    end

  end

  if ::Enumerable.method_defined?(:slice_before)

    describe "#slice_before" do

      let(:words) do
        %w(One two three Two two three)
      end

      it "can slice with a pattern" do
        expect(words.lazily.slice_before(/^[A-Z]/).to_a).to eq([
          %w(One two three),
          %w(Two two three)
        ])
      end

      it "can slice with a block" do
        expect(words.lazily.slice_before { |w| w =~ /^[A-Z]/ }.to_a).to eq([
          %w(One two three),
          %w(Two two three)
        ])
      end

      it "is lazy" do
        expect(words.ecetera.lazily.slice_before(/^[A-Z]/)).to be_lazy
      end

    end

  end

  if ::Enumerable.method_defined?(:chunk)

    describe "#chunk" do

      it "groups elements by the result of a block" do
        expect([3,1,4,1,5,9,2,6].lazily.chunk(&:even?).to_a).to eq([
          [false, [3, 1]],
          [true, [4]],
          [false, [1, 5, 9]],
          [true, [2, 6]],
        ])
      end

      it "is lazy" do
        expect([3,1,4,1,5,9,2,6].ecetera.lazily.chunk(&:even?)).to be_lazy
      end

    end

  end

  describe "#compact" do

    it "omits nils" do
      expect([1, "too", nil, true, nil, false].lazily.compact.to_a).to eq([1, "too", true, false])
    end

    it "is lazy" do
      expect([nil].ecetera.lazily.compact).to be_lazy
    end

  end

  describe "#[]" do

    let(:evens) do
      (1..999).lazily.collect { |x| x * 2 }
    end

    it "finds the specified element" do
      expect(evens.lazily[2]).to eq(6)
    end

    it "is lazy" do
      expect(evens.ecetera.lazily[3]).to eq(8)
    end

  end

end

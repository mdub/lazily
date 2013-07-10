require "spec_helper"

describe Lazily, "associating" do

  describe ".associate" do

    context "with two identical Enumerables" do

      let(:collectionA) { [2,4,6] }
      let(:collectionB) { collectionA }

      let(:result) do
        Lazily.associate(:A => collectionA, :B => collectionB)
      end

      it "yields matched pairs" do
        expect(result.to_a).to eq [
          { :A => [2], :B => [2] },
          { :A => [4], :B => [4] },
          { :A => [6], :B => [6] }
        ]
      end

    end

    context "with three identical Enumerables" do

      let(:collectionA) { [1,2]}
      let(:collectionB) { collectionA }
      let(:collectionC) { collectionA }

      let(:result) do
        Lazily.associate(:A => collectionA, :B => collectionB, :C => collectionC)
      end

      it "yields matched triples" do
        expect(result.to_a).to eq [
          { :A => [1], :B => [1], :C => [1] },
          { :A => [2], :B => [2], :C => [2] }
        ]
      end

    end

    context "when elements are missing" do

      let(:collectionA) { [1,2] }
      let(:collectionB) { [2,3] }
      let(:collectionC) { [1,3] }

      let(:result) do
        Lazily.associate(:A => collectionA, :B => collectionB, :C => collectionC)
      end

      it "returns an empty Array for the corresponding label" do
        expect(result.to_a).to eq [
          { :A => [1], :B => [ ], :C => [1] },
          { :A => [2], :B => [2], :C => [ ] },
          { :A => [ ], :B => [3], :C => [3] }
        ]
      end

    end

    context "with a block" do

      let(:colours) { %w(blue red) }
      let(:fruits)  { %w(apple banana cranberry) }
      let(:shapes)  { %w(circle rectangle triangle) }

      let(:result) do
        Lazily.associate(:c => colours, :f => fruits, :s => shapes) do |word|
          word.chars.first
        end
      end

      it "uses the block to associate the elements" do
        expect(result.to_a).to eq [
          { :c => [], :f => ['apple'], :s => [] },
          { :c => ['blue'], :f => ['banana'], :s => [] },
          { :c => [], :f => ['cranberry'], :s => ['circle'] },
          { :c => ['red'], :f => [], :s => ['rectangle'] },
          { :c => [], :f => [], :s => ['triangle'] }
        ]
      end

    end

    it "is lazy" do
      result = Lazily.associate(:a => [1,2].ecetera, :b => [3,4].ecetera )
      expect(result.first).to eq(:a => [1], :b => [])
    end

  end

end

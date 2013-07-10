require "spec_helper"

describe Lazily, "associating" do

  describe ".associate" do

    let(:result) do
      Lazily.associate(:A => collectionA, :B => collectionB).to_a
    end

    context "with two identical Enumerables" do

      let(:collectionA) { [2,4,6]}
      let(:collectionB) { collectionA }

      it "yields matched pairs" do
        expect(result).to eq [
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
        Lazily.associate(:A => collectionA, :B => collectionB, :C => collectionC).to_a
      end

      it "yields matched triples" do
        expect(result).to eq [
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
        Lazily.associate(:A => collectionA, :B => collectionB, :C => collectionC).to_a
      end

      it "omits the key for the corresponding enumerable" do
        expect(result).to eq [
          { :A => [1], :C => [1] },
          { :A => [2], :B => [2] },
          { :B => [3], :C => [3] }
        ]
      end

    end

  end

end

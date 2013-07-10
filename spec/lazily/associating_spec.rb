require "spec_helper"

describe Lazily, "associating" do

  let(:collectionA) { [2,4,6]}

  describe ".associate" do

    let(:result) do
      Lazily.associate(:A => collectionA, :B => collectionB).to_a
    end

    context "with two identical Enumerables" do

      let(:collectionB) { collectionA }

      it "returns matched pairs" do
        expect(result).to eq [
          { :A => [2], :B => [2] },
          { :A => [4], :B => [4] },
          { :A => [6], :B => [6] }
        ]
      end

    end

  end

end

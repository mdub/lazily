require "spec_helper"

describe Lazily, "concatenating" do

  let(:array1) { [1,5,3] }
  let(:array2) { [2,9,4] }

  describe ".concat" do

    it "concatenates multiple Enumerables" do
      result = Lazily.concat(array1, array2)
      result.to_a.should == array1 + array2
    end

    it "is lazy" do
      Lazily.concat(array1, array2.with_time_bomb).should be_lazy
    end

  end

  describe "#concat" do

    it "concatenates multiple Enumerables" do
      result = array1.lazily.concat(array2)
      result.to_a.should == array1 + array2
    end

    it "is lazy" do
      result = array1.lazily.concat(array2.with_time_bomb)
      result.take(3).to_a.should == (array1 + array2).take(3)
    end

  end

end

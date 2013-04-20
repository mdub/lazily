require "spec_helper"

describe Lazily, "concatenating" do

  describe ".concat" do

    it "concatenates multiple Enumerables" do
      result = Lazily.concat([1,5,3], [2,9,4])
      result.to_a.should == [1,5,3,2,9,4]
    end

    it "is lazy" do
      result = Lazily.concat([3,4], [1,2].with_time_bomb)
      result.take(3).to_a.should == [3,4,1]
    end

  end

  describe "#concat" do

    it "concatenates multiple Enumerables" do
      result = [1,5,3].lazily.concat([2,9,4])
      result.to_a.should == [1,5,3,2,9,4]
    end

    it "is lazy" do
      result = [3,4].lazily.concat([1,2].with_time_bomb)
      result.take(3).to_a.should == [3,4,1]
    end

  end

end

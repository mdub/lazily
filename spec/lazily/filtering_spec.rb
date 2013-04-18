require "spec_helper"

describe Lazily, "filtering" do

  describe "#collect" do

    it "transforms items" do
      [1,2,3].lazily.collect { |x| x * 2 }.to_a.should == [2,4,6]
    end

    it "is lazy" do
      [1,2,3].with_time_bomb.lazily.collect { |x| x * 2 }.first.should == 2
    end

  end

end

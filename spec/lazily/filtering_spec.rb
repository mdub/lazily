require "spec_helper"

describe Lazily, "filter" do

  describe "#collect" do

    it "transforms items" do
      [1,2,3].lazily.collect { |x| x * 2 }.to_a.should == [2,4,6]
    end

    it "is lazy" do
      [1,2,3].with_time_bomb.lazily.collect { |x| x * 2 }.should be_lazy
    end

  end

  describe "#select" do

    it "excludes items that don't pass the predicate" do
      (1..6).lazily.select { |x| x%2 == 0 }.to_a.should == [2,4,6]
    end

    it "is lazy" do
      (1..6).with_time_bomb.lazily.select { |x| x%2 == 0 }.should be_lazy
    end

  end

  describe "#reject" do

    it "excludes items that do pass the predicate" do
      (1..6).lazily.reject { |x| x%2 == 0 }.to_a.should == [1,3,5]
    end

    it "is lazy" do
      (1..6).with_time_bomb.lazily.reject { |x| x%2 == 0 }.should be_lazy
    end

  end

  describe "#uniq" do

    it "removes duplicates" do
      [1,3,2,4,3,5,4,6].lazily.uniq.to_a.should == [1,3,2,4,5,6]
    end

    it "is lazy" do
      [1,2,3].with_time_bomb.lazily.uniq.should be_lazy
    end

  end

  describe "#uniq_by" do

    it "uses the block to derive identity" do
      array = %w(A1 A2 B1 A3 C1 B2 C2)
      array.lazily.uniq_by { |s| s[0,1] }.to_a.should == %w(A1 B1 C1)
    end

  end

  describe "#take" do

    it "includes the specified number" do
      array = [1,2,3,4]
      array.lazily.take(3).to_a.should == [1,2,3]
    end

    it "is lazy" do
      [1,2].with_time_bomb.lazily.take(2).should be_lazy
    end

    it "copes with 0" do
      [].with_time_bomb.lazily.take(0).to_a.should == []
    end

  end

  describe "#take_while" do

    it "takees elements as long as the predicate is true" do
      array = [2,4,6,3]
      array.lazily.take_while(&:even?).to_a.should == [2,4,6]
    end

    it "is lazy" do
      [2,3].with_time_bomb.lazily.take_while(&:even?).should be_lazy
    end

  end

  describe "#drop" do

    it "excludes the specified number" do
      array = [1,2,3,4]
      array.lazily.drop(2).to_a.should == [3,4]
    end

    it "is lazy" do
      [1,2,3,4].with_time_bomb.lazily.drop(2).lazily.take(1).to_a.should == [3]
    end

  end

  describe "#drop_while" do

    it "drops elements as long as the predicate is true" do
      array = [2,4,6,3,4]
      array.lazily.drop_while(&:even?).to_a.should == [3,4]
    end

    it "is lazy" do
      [2,3].with_time_bomb.lazily.drop_while(&:even?).lazily.should be_lazy
    end

  end

  describe "#grep" do

    let(:fruits) { %w(apple banana pear orange) }

    it "returns elements matching a pattern" do
      fruits.lazily.grep(/e$/).to_a.should == %w(apple orange)
    end

    it "applies the associated block" do
      fruits.lazily.grep(/e$/, &:capitalize).to_a.should == %w(Apple Orange)
    end

    it "is lazy" do
      fruits.with_time_bomb.lazily.grep(/p/).should be_lazy
    end

  end

  describe "#[]" do

    let(:evens) do
      (1..999).lazily.collect { |x| x * 2 }
    end

    it "finds the specified element" do
      evens.lazily[2].should == 6
    end

    it "is lazy" do
      evens.with_time_bomb.lazily[3].should == 8
    end

  end

end

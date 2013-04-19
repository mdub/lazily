require "spec_helper"

describe Lazily, "zipping", :needs_enumerators => true do

  let(:array1) { [1,3,6] }
  let(:array2) { [2,4,7] }
  let(:array3) { [5,8] }

  describe ".zip" do

    it "zips together multiple Enumerables" do
      zip = Lazily.zip(array1, array2, array3)
      zip.to_a.should == [[1,2,5], [3,4,8], [6,7,nil]]
    end

    it "is lazy" do
      zip = Lazily.zip(%w(a b c), [1,2].with_time_bomb)
      zip.take(2).to_a.should == [["a", 1], ["b", 2]]
    end

  end

  describe "#zip" do

    it "zips an Enumerable with multiple others" do
      zip = array1.lazily.zip(array2, array3)
      zip.to_a.should == [[1,2,5], [3,4,8], [6,7,nil]]
    end

    it "is lazy" do
      zip = %w(a b c).lazily.zip([1,2].with_time_bomb)
      zip.take(2).to_a.should == [["a", 1], ["b", 2]]
    end

  end

end

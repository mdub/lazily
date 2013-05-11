require "spec_helper"

describe Lazily, :needs_enumerators => true do

  describe ".merge" do

    it "merges multiple Enumerators" do
      array1 = [1,3,6]
      array2 = [2,4,7]
      array3 = [5,8]
      merged = Lazily.merge(array1, array2, array3)
      merged.to_a.should == [1,2,3,4,5,6,7,8]
    end

    it "is lazy" do
      enum1 = [1,3,6]
      enum2 = [2,4,7].with_time_bomb
      merged = Lazily.merge(enum1, enum2)
      merged.take(4).to_a.should == [1,2,3,4]
    end

  end

  describe ".merge_by" do

    it "uses the block to determine order" do
      array1 = %w(cccc dd a)
      array2 = %w(eeeee bbb)
      merged = Lazily.merge_by(array1, array2) { |s| -s.length }
      merged.to_a.should == %w(eeeee cccc bbb dd a)
    end

  end

end

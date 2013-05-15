require "spec_helper"

describe Lazily, "zipping" do

  let(:array1) { [1,3,6] }
  let(:array2) { [2,4,7] }
  let(:array3) { [5] }

  describe ".zip" do

    it "zips together multiple Enumerables" do
      zip = Lazily.zip(array1, array2, array3)
      zip.to_a.should == array1.zip(array2, array3)
    end

    it "is lazy" do
      Lazily.zip(array1, array2.ecetera).should be_lazy
    end

  end

  describe "#zip" do

    it "zips an Enumerable with multiple others" do
      zip = array1.lazily.zip(array2, array3)
      zip.to_a.should == array1.zip(array2, array3)
    end

    it "is lazy" do
      array1.lazily.zip(array2.ecetera).should be_lazy
    end

  end

end

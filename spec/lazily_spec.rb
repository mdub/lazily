require "spec_helper"

describe "Lazily", "method" do

  it "returns a lazy proxy" do
    Lazily([1,2,3]).should be_lazy
  end

end

describe "Enumerable", "#lazily" do

  it "returns a lazy proxy" do
    [1,2,3].lazily.should be_lazy
  end

end

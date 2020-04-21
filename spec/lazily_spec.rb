require "spec_helper"

describe "Lazily", "method" do

  it "returns a lazy proxy" do
    expect(Lazily([1,2,3])).to be_lazy
  end

end

describe "Enumerable", "#lazily" do

  it "returns a lazy proxy" do
    expect([1,2,3].lazily).to be_lazy
  end

end

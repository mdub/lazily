require "spec_helper"

describe Lazily, "squashing bugs" do

  example "#prefetch and #take interact well" do
    expect([1,2,3].lazily.take(3).prefetch(2).take(1).to_a).to eq([1])
  end

end

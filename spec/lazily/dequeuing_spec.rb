require "spec_helper"
require "thread"
require "timeout"

describe Lazily, "dequeuing" do

  let(:queue) { Queue.new }

  describe ".dequeue" do

    it "drains a queue" do
      queue << "one"
      queue << "two"
      queue << "three"
      queue << nil
      Lazily.dequeue(queue).to_a.should == %w(one two three)
    end

    it "polls the queue" do
      lambda do
        Timeout.timeout(0.1) do
          Lazily.dequeue(queue).first
        end
      end.should raise_error(TimeoutError)
    end

    it "is lazy" do
      queue << "one"
      Timeout.timeout(0.1) do
        Lazily.dequeue(queue).first.should eq("one")
      end
    end

  end

end

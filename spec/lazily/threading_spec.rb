require "spec_helper"

describe Lazily, "threading" do

  describe "#in_threads" do

    it "acts like #collect" do
      [1,2,3].lazily.in_threads(5) { |x| x * 2 }.to_a.should == [2,4,6]
    end

    it "runs things in separate threads" do
      [1,2,3].lazily.in_threads(5) { Thread.current.object_id }.to_a.uniq.size.should eq(3)
    end

    it "is lazy" do
      [1,2,3].with_time_bomb.lazily.in_threads(2) { |x| x * 2 }.first.should == 2
    end

    def round(n, accuracy = 0.02)
      (n / accuracy).round.to_f * accuracy
    end

    it "runs the specified number of threads in parallel" do
      delays = [0.03, 0.03, 0.03]
      start = Time.now
      delays.lazily.in_threads(2) do |delay|
        sleep(delay)
      end.to_a
      round(Time.now - start).should eq(0.06)
    end

    it "acts as a sliding window" do
      delays = [0.1, 0.08, 0.06, 0.04, 0.02]
      start = Time.now
      elapsed_times = delays.lazily.in_threads(3) do |delay|
        sleep(delay)
        round(Time.now - start)
      end
      elapsed_times.to_a.should eq([0.1, 0.08, 0.06, 0.14, 0.12])
    end

    it "surfaces exceptions" do
      lambda do
        [1,2,3].lazily.in_threads(5) { raise "hell" }.to_a
      end.should raise_error(RuntimeError, "hell")
    end

  end

end

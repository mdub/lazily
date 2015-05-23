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
      [1,2,3].ecetera.lazily.in_threads(2) { |x| x * 2 }.should be_lazy
    end

    def round(n, accuracy = 20)
      (n * accuracy).round.to_f / accuracy
    end

    it "runs the specified number of threads in parallel" do
      delays = [0.05, 0.05, 0.05]
      start = Time.now
      delays.lazily.in_threads(2) do |delay|
        sleep(delay)
      end.to_a
      round(Time.now - start).should eq(0.1)
    end

    it "acts as a sliding window" do
      delays = [0.1, 0.15, 0.05, 0.05, 0.05]
      start = Time.now
      elapsed_times = delays.lazily.in_threads(3) do |delay|
        sleep(delay)
        round(Time.now - start)
      end
      elapsed_times.to_a.should eq([0.1, 0.15, 0.05, 0.15, 0.2])
    end

    it "surfaces exceptions" do
      lambda do
        [1,2,3].lazily.in_threads(5) { raise "hell" }.to_a
      end.should raise_error(RuntimeError, "hell")
    end

    context "with less than 2 threads" do

      it "acts like #collect" do
        [1, 0, nil].each do |n|
          [1,2,3].lazily.in_threads(n) { |x| x * 2 }.to_a.should == [2,4,6]
        end
      end

    end

  end

end

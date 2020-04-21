require "spec_helper"

describe Lazily, "threading" do

  describe "#in_threads" do

    it "acts like #collect" do
      expect([1,2,3].lazily.in_threads(5) { |x| x * 2 }.to_a).to eq([2,4,6])
    end

    it "runs things in separate threads" do
      expect([1,2,3].lazily.in_threads(5) { Thread.current.object_id }.to_a.uniq.size).to eq(3)
    end

    it "is lazy" do
      expect([1,2,3].ecetera.lazily.in_threads(2) { |x| x * 2 }).to be_lazy
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
      expect(round(Time.now - start)).to eq(0.1)
    end

    it "acts as a sliding window" do
      delays = [0.1, 0.15, 0.05, 0.05, 0.05]
      start = Time.now
      elapsed_times = delays.lazily.in_threads(3) do |delay|
        sleep(delay)
        round(Time.now - start)
      end
      expect(elapsed_times.to_a).to eq([0.1, 0.15, 0.05, 0.15, 0.2])
    end

    it "surfaces exceptions" do
      expect do
        [1,2,3].lazily.in_threads(5) do 
          Thread.current.report_on_exception = false if Thread.current.respond_to?(:report_on_exception=)
          raise "hell" 
        end.to_a
      end.to raise_error(RuntimeError, "hell")
    end

    context "with less than 2 threads" do

      it "acts like #collect" do
        [1, 0, nil].each do |n|
          expect([1,2,3].lazily.in_threads(n) { |x| x * 2 }.to_a).to eq([2,4,6])
        end
      end

    end

  end

end

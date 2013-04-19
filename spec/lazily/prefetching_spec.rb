require "spec_helper"

describe Lazily do

  Counter = Class.new do

    include Enumerable

    def initialize(source)
      @source = source
      @number_yielded = 0
    end

    def each
      @source.each do |item|
        @number_yielded += 1
        yield item
      end
    end

    attr_reader :number_yielded

  end

  describe "#prefetch" do

    let(:source) { [1, 2, 3, 4, nil, false, 7] }

    it "yields all items" do
      source.lazily.prefetch(2).to_a.should eq(source)
      source.lazily.prefetch(3).to_a.should eq(source)
    end

    it "is stateless" do
      source.lazily.prefetch(2).first.should eq(source.first)
      source.lazily.prefetch(2).first.should eq(source.first)
    end

    it "is lazy" do
      source.with_time_bomb.lazily.prefetch(2).first.should eq(source.first)
    end

    it "pre-computes the specified number of elements" do
      counter = Counter.new(source)
      counter.lazily.prefetch(2).first
      counter.number_yielded.should eq(3)
    end

    context "with a buffer size of zero" do

      it "does not pre-fetch anything" do
        counter = Counter.new(source)
        counter.lazily.prefetch(0).first
        counter.number_yielded.should eq(1)
      end

    end

    context "with a buffer bigger than the source Enumerable" do

      it "yields all items" do
        source.lazily.prefetch(20).to_a.should eq(source)
      end

    end

  end

end

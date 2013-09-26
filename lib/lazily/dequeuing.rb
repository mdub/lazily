require "lazily/enumerable"

module Lazily

  class << self

    def dequeue(queue)
      Dequeuer.new(queue)
    end

  end

  class Dequeuer

    include Lazily::Enumerable

    def initialize(queue, terminator = nil)
      @queue = queue
      @terminator = terminator
    end

    def each
      loop do
        next_value = @queue.pop
        break if @terminator === next_value
        yield next_value
      end
    end

  end

end

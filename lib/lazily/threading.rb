require "lazily/prefetching"

module Lazily

  module Enumerable

    def in_threads(max_threads, &block)
      collect do |item|
        Thread.new { block.call(item) }
      end.prefetch(max_threads - 1).collect do |thread|
        thread.join.value
      end
    end
  end

end

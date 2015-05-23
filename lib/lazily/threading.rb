require "lazily/prefetching"

module Lazily

  module Enumerable

    def in_threads(max_threads, &block)
      max_threads ||= 1
      if max_threads < 2
        return collect(&block)
      end
      collect do |item|
        Thread.new { block.call(item) }
      end.prefetch(max_threads - 1).collect do |thread|
        thread.join.value
      end
    end
  end

end

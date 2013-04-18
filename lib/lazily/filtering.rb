require "lazily/enumerable"

module Lazily

  module Filtering

    class LazyFilter

      include Enumerable

      def initialize(&generator)
        @generator = generator
      end

      def each
        return to_enum unless block_given?
        yielder = proc { |x| yield x }
        @generator.call(yielder)
      end

    end

    def collect
      LazyFilter.new do |output|
        each do |element|
          output.call yield(element)
        end
      end
    end

  end

end

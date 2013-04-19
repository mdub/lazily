require "lazily/enumerable"

module Lazily

  module Filtering

    class LazyFilter

      include Lazily::Enumerable

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

    alias map collect

    def select
      LazyFilter.new do |output|
        each do |element|
          output.call(element) if yield(element)
        end
      end
    end

    alias find_all select

    def reject
      LazyFilter.new do |output|
        each do |element|
          output.call(element) unless yield(element)
        end
      end
    end

    def uniq
      LazyFilter.new do |output|
        seen = Set.new
        each do |element|
          output.call(element) if seen.add?(element)
        end
      end
    end

    def uniq_by
      LazyFilter.new do |output|
        seen = Set.new
        each do |element|
          output.call(element) if seen.add?(yield element)
        end
      end
    end

    def take(n)
      LazyFilter.new do |output|
        if n > 0
          each_with_index do |element, index|
            output.call(element)
            break if index + 1 == n
          end
        end
      end
    end

    def take_while
      LazyFilter.new do |output|
        each do |element|
          break unless yield(element)
          output.call(element)
        end
      end
    end

    def drop(n)
      LazyFilter.new do |output|
        each_with_index do |element, index|
          next if index < n
          output.call(element)
        end
      end
    end

    def drop_while
      LazyFilter.new do |output|
        take = false
        each do |element|
          take ||= !yield(element)
          output.call(element) if take
        end
      end
    end

    def [](n)
      drop(n).first
    end

  end

  module Enumerable
    include Filtering
  end

end

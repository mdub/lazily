require "lazily/enumerable"

module Lazily

  class Filtering

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

  module Enumerable

    def collect
      Filtering.new do |output|
        each do |element|
          output.call yield(element)
        end
      end
    end

    alias map collect

    def select
      Filtering.new do |output|
        each do |element|
          output.call(element) if yield(element)
        end
      end
    end

    alias find_all select

    def reject
      Filtering.new do |output|
        each do |element|
          output.call(element) unless yield(element)
        end
      end
    end

    def uniq
      Filtering.new do |output|
        seen = Set.new
        each do |element|
          output.call(element) if seen.add?(element)
        end
      end
    end

    def uniq_by
      Filtering.new do |output|
        seen = Set.new
        each do |element|
          output.call(element) if seen.add?(yield element)
        end
      end
    end

    def take(n)
      Filtering.new do |output|
        if n > 0
          each_with_index do |element, index|
            output.call(element)
            break if index + 1 == n
          end
        end
      end
    end

    def take_while
      Filtering.new do |output|
        each do |element|
          break unless yield(element)
          output.call(element)
        end
      end
    end

    def drop(n)
      Filtering.new do |output|
        each_with_index do |element, index|
          next if index < n
          output.call(element)
        end
      end
    end

    def drop_while
      Filtering.new do |output|
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

end

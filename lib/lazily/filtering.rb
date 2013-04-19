require "lazily/enumerable"

module Lazily

  module Enumerable

    def collect
      Filter.new do |output|
        each do |element|
          output.call yield(element)
        end
      end
    end

    alias map collect

    def select
      Filter.new do |output|
        each do |element|
          output.call(element) if yield(element)
        end
      end
    end

    alias find_all select

    def reject
      Filter.new do |output|
        each do |element|
          output.call(element) unless yield(element)
        end
      end
    end

    def uniq
      Filter.new do |output|
        seen = Set.new
        each do |element|
          output.call(element) if seen.add?(element)
        end
      end
    end

    def uniq_by
      Filter.new do |output|
        seen = Set.new
        each do |element|
          output.call(element) if seen.add?(yield element)
        end
      end
    end

    def take(n)
      Filter.new do |output|
        if n > 0
          each_with_index do |element, index|
            output.call(element)
            throw Lazily::Filter::DONE if index + 1 == n
          end
        end
      end
    end

    def take_while
      Filter.new do |output|
        each do |element|
          throw Lazily::Filter::DONE unless yield(element)
          output.call(element)
        end
      end
    end

    def drop(n)
      Filter.new do |output|
        each_with_index do |element, index|
          next if index < n
          output.call(element)
        end
      end
    end

    def drop_while
      Filter.new do |output|
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

  class Filter

    include Lazily::Enumerable

    def initialize(&generator)
      @generator = generator
    end

    DONE = "Lazily::DONE".to_sym

    def each
      return to_enum unless block_given?
      yielder = proc { |x| yield x }
      catch DONE do
        @generator.call(yielder)
      end
    end

  end

end

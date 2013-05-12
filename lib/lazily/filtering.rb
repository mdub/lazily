require "lazily/enumerable"

module Lazily

  module Enumerable

    def collect
      filter("collect") do |output|
        each do |element|
          output.call yield(element)
        end
      end
    end

    alias map collect

    def select
      filter("select") do |output|
        each do |element|
          output.call(element) if yield(element)
        end
      end
    end

    alias find_all select

    def reject
      filter("reject") do |output|
        each do |element|
          output.call(element) unless yield(element)
        end
      end
    end

    def uniq
      filter("uniq") do |output|
        seen = Set.new
        each do |element|
          key = if block_given?
            yield element
          else
            element
          end
          output.call(element) if seen.add?(key)
        end
      end
    end

    def take(n)
      filter("take") do |output|
        if n > 0
          each_with_index do |element, index|
            output.call(element)
            throw Filter::DONE if index + 1 == n
          end
        end
      end
    end

    def take_while
      filter("take_while") do |output|
        each do |element|
          throw Filter::DONE unless yield(element)
          output.call(element)
        end
      end
    end

    def drop(n)
      filter("drop") do |output|
        each_with_index do |element, index|
          next if index < n
          output.call(element)
        end
      end
    end

    def drop_while
      filter("drop_while") do |output|
        take = false
        each do |element|
          take ||= !yield(element)
          output.call(element) if take
        end
      end
    end

    def grep(pattern, &block)
      filter("grep") do |output|
        each do |element|
          if pattern === element
            element = block.call(element) if block
            output.call(element)
          end
        end
      end
    end

    def flatten(level = 1)
      filter("flatten") do |output|
        each do |element|
          if level > 0 && element.respond_to?(:each)
            element.flatten(level - 1).each(&output)
          else
            output.call(element)
          end
        end
      end
    end

    def flat_map(&block)
      map(&block).flatten
    end

    alias collect_concat flat_map

    def slice_before(*args, &block)
      super.lazily
    end

    # TODO:
    #   - chunk

    def [](n)
      drop(n).first
    end

    private

    def filter(method, &block)
      Filter.new(self, method, &block)
    end

  end

  class Filter

    include Lazily::Enumerable

    def initialize(source, method, &generator)
      @source = source
      @method = method
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

    def inspect
      "#<#{self.class}: #{@method} #{@source.inspect}>"
    end

  end

end

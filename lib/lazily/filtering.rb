require "lazily/enumerable"

module Lazily

  module Enumerable

    # Transform elements using the block provided.
    # @return [Enumerable] the transformed elements
    #
    # @see ::Enumerable#collect
    #
    def collect(&transformation)
      filter("collect") do |output|
        each do |element|
          output.call yield(element)
        end
      end
    end

    alias map collect

    # Select elements using a predicate block.
    #
    # @return [Enumerable] the elements that pass the predicate
    #
    # @see ::Enumerable#select
    #
    def select(&predicate)
      filter("select") do |output|
        each do |element|
          output.call(element) if yield(element)
        end
      end
    end

    alias find_all select

    # Select elements that fail a test.
    #
    # @yield [element] each element
    # @yieldreturn [Boolean] truthy if the element passed the test
    # @return [Enumerable] the elements which failed the test
    #
    # @see ::Enumerable#reject
    #
    def reject
      filter("reject") do |output|
        each do |element|
          output.call(element) unless yield(element)
        end
      end
    end

    # Remove duplicate values.
    #
    # @return [Enumerable] elements which have not been previously encountered
    # @overload uniq
    #
    # @overload uniq(&block)
    #
    # @see ::Enumerable#uniq
    #
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

    # Select the first n elements.
    #
    # @param n [Integer] the number of elements to take
    # @return [Enumerable] the first N elements
    #
    # @see ::Enumerable#take
    #
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

    # Select elements while a predicate returns true.
    #
    # @return [Enumerable] all elements before the first that fails the predicate
    #
    # @see ::Enumerable#take_while
    #
    def take_while(&predicate)
      filter("take_while") do |output|
        each do |element|
          throw Filter::DONE unless yield(element)
          output.call(element)
        end
      end
    end

    # Ignore the first n elements.
    #
    # @param n [Integer] the number of elements to drop
    # @return [Enumerable] elements after the first N
    #
    # @see ::Enumerable#drop
    #
    def drop(n)
      filter("drop") do |output|
        each_with_index do |element, index|
          next if index < n
          output.call(element)
        end
      end
    end

    # Reject elements while a predicate returns true.
    #
    # @return [Enumerable] all elements including and after the first that fails the predicate
    #
    # @see ::Enumerable#drop_while
    #
    def drop_while(&predicate)
      filter("drop_while") do |output|
        take = false
        each do |element|
          take ||= !yield(element)
          output.call(element) if take
        end
      end
    end

    # Select elements matching a pattern.
    #
    # @return [Enumerable] elements for which the pattern matches
    #
    # @see ::Enumerable#grep
    #
    def grep(pattern)
      filter("grep") do |output|
        each do |element|
          if pattern === element
            result = if block_given?
              yield element
            else
              element
            end
            output.call(result)
          end
        end
      end
    end

    # Flatten the collection, such that Enumerable elements are included inline.
    #
    # @return [Enumerable] elements of elements of the collection
    #
    # @see ::Array#flatten
    #
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

    # Ignore nil values.
    #
    # @return [Enumerable] the elements that are not nil
    #
    # @see ::Array#compact
    #
    def compact
      filter("compact") do |output|
        each do |element|
          output.call(element) unless element.nil?
        end
      end
    end

    def slice_before(*args, &block)
      super.lazily
    end

    def chunk(*args, &block)
      super.lazily
    end

    # @return the nth element
    #
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

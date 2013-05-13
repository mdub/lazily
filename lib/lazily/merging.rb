require "lazily/enumerable"

module Lazily

  class << self

    # Merge a number of sorted Enumerables into a single sorted collection.
    #
    # Draws elements from enumerables as appropriate, to preserve the sort order. An optional block, if provided, is used for comparison of elements.
    # Otherwise, natural element order is used.
    #
    # @param enumerables [Array<Enumerable>]
    # @return [Enumerable] merged, sorted elements
    #
    # @example
    #   array1 = [1,4,5]
    #   array2 = [2,3,6]
    #   Lazily.merge(array1, array2)        #=> [1,2,3,4,5,6]
    #
    def merge(*enumerables, &block)
      Merger.new(enumerables, &block)
    end

  end

  class Merger

    include Lazily::Enumerable

    def initialize(enumerables, &transformer)
      @enumerables = enumerables
      @transformer = transformer
    end

    def each(&block)
      return to_enum unless block_given?
      Generator.new(@enumerables.map(&:to_enum), @transformer).each(&block)
    end

    class Generator

      def initialize(enumerators, transformer)
        @enumerators = enumerators
        @transformer = transformer
      end

      def each
        loop do
          discard_empty_enumerators
          break if @enumerators.empty?
          yield next_enumerator.next
        end
      end

      private

      def discard_empty_enumerators
        @enumerators.delete_if do |e|
          begin
            e.peek
            false
          rescue StopIteration
            true
          end
        end
      end

      def next_enumerator
        @enumerators.min_by { |enumerator| transform(enumerator.peek) }
      end

      def transform(item)
        return item unless @transformer
        @transformer.call(item)
      end

    end

  end

end

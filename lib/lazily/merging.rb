require "lazily/enumerable"

module Lazily

  class Merging

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

  class << self

    def merge(*enumerables)
      Merging.new(enumerables)
    end

    def merge_by(*enumerables, &block)
      Merging.new(enumerables, &block)
    end

  end

end

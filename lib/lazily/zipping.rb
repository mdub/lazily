require "lazily/enumerable"

module Lazily

  class LazyZipper

    include Lazily::Enumerable

    def initialize(enumerables)
      @enumerables = enumerables
    end

    def each
      enumerators = @enumerables.map(&:to_enum)
      while true
        chunk = enumerators.map do |enumerator|
          begin
            enumerator.next
          rescue StopIteration
            nil
          end
        end
        break if chunk.all?(&:nil?)
        yield chunk
      end
    end

  end

  class << self

    def zip(*enumerables)
      LazyZipper.new(enumerables)
    end

  end

  module Enumerable

    def zip(*others)
      Lazily.zip(self, *others)
    end

  end

end

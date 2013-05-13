require "lazily/enumerable"

module Lazily

  class << self

    # Concatenates two or more Enumerables.
    #
    # @param enumerables [Array<Enumerable>]
    # @return [Enumerable] elements of all the enumerables
    #
    # @example
    #   array1 = [1,4,5]
    #   array2 = [2,3,6]
    #   Lazily.concat(array1, array2)       #=> [1,4,5,2,3,6]
    #
    def concat(*enumerables)
      Concatenator.new(enumerables)
    end

  end

  module Enumerable

    # Concatenates this and other Enumerables.
    #
    # @param others [Array<Enumerable>]
    # @return [Enumerable] elements of this and other Enumerables
    #
    # @see Array#concat
    #
    def concat(*others)
      Lazily.concat(self, *others)
    end

  end

  class Concatenator

    include Lazily::Enumerable

    def initialize(enumerables)
      @enumerables = enumerables
    end

    def each(&block)
      @enumerables.each do |enumerable|
        enumerable.each(&block)
      end
    end

  end

end

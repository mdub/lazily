require "lazily/enumerable"

module Lazily

  class << self

    # Concatenates two or more Enumerables.
    #
    # @param enumerables [Array<Enumerable>]
    # @return [Enumerable] elements of all the enumerables
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

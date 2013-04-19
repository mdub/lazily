require "lazily/enumerable"

module Lazily

  class << self

    def concat(*enumerables)
      Concatenator.new(enumerables)
    end

  end

  module Enumerable

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

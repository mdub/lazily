require "lazily/enumerable"

module Lazily

  class Concatenating

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

  class << self

    def concat(*enumerables)
      Concatenating.new(enumerables)
    end

  end

  module Enumerable

    def concat(*others)
      Lazily.concat(self, *others)
    end

  end
end

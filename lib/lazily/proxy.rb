require "lazily/enumerable"

module Lazily

  class Proxy

    include Lazily::Enumerable

    def initialize(source)
      @source = source
    end

    def each(&block)
      return to_enum unless block
      @source.each(&block)
    end

  end

end

require "lazily/enumerable"

def Lazily(enumerable)
  Lazily::Proxy.new(enumerable)
end

module ::Enumerable

  def lazily
    Lazily::Proxy.new(self)
  end

end

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

require "lazily/enumerable"
require "lazily/proxy"

module Enumerable

  def lazily
    Lazily::Proxy.new(self)
  end

end

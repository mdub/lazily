require "lazily/filtering"
require "lazily/zipping"
require "lazily/proxy"

module ::Enumerable

  def lazily
    Lazily::Proxy.new(self)
  end

end

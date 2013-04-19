require "lazily/combining"
require "lazily/filtering"
require "lazily/proxy"

def Lazily(enumerable)
  Lazily::Proxy.new(enumerable)
end

module ::Enumerable

  def lazily
    Lazily::Proxy.new(self)
  end

end

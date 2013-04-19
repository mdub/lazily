module Lazily

  module Enumerable

    include ::Enumerable

    require "lazily/filtering"
    include Filtering

  end

end

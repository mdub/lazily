module Lazily

  module Enumerable

    include ::Enumerable

    # @return true
    def lazy?
      true
    end

    def lazily
      self
    end

  end

end

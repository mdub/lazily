module Lazily

  module Enumerable

    include ::Enumerable

    def lazy?
      true
    end

    def lazily
      self
    end

  end

end

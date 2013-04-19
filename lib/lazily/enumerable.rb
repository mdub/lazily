module Lazily

  module Enumerable

    include ::Enumerable

    def lazy?
      true
    end

  end

end

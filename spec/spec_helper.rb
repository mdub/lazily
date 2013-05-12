require "lazily"

class NotLazyEnough < StandardError; end

class Ecetera

  include Enumerable

  def initialize(source)
    @source = source
  end

  def each(&block)
    @source.each(&block)
    raise NotLazyEnough
  end

end

module Enumerable

  # extend an Enumerable to throw an exception after last element
  def ecetera
    Ecetera.new(self)
  end

  unless method_defined?(:first)
    def first
      each do |first_item|
        return first_item
      end
    end
  end

end

RSpec.configure do |config|
  unless defined?(::Enumerator)
    config.filter_run_excluding :needs_enumerators => true
  end
end

require "lazily"

class NotLazyEnough < StandardError; end

class WithTimeBomb

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
  def with_time_bomb
    WithTimeBomb.new(self)
  end

  unless method_defined?(:first)
    def first
      each do |first_item|
        return first_item
      end
    end
  end

end

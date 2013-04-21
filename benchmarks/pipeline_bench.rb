require 'benchmark'

$: << File.expand_path("../../lib", __FILE__)

array = (1..100000).to_a

# Test scenario:
#  - filter out even numbers
#  - square them
#  - grab the first thousand

printf "%-30s", "IMPLEMENTATION"
printf "%12s", "take(10)"
printf "%12s", "take(100)"
printf "%12s", "take(1000)"
printf "%12s", "to_a"
puts ""

def measure(&block)
  begin
    printf "%12.5f", Benchmark.realtime(&block)
  rescue
    printf "%12s", "n/a"
  end
end

def benchmark(description, control_result = nil)
  result = nil
  printf "%-30s", description
  measure { yield.take(10).to_a }
  measure { yield.take(100).to_a }
  measure { result = yield.take(1000).to_a }
  measure { yield.to_a }
  puts ""
  unless control_result.nil? || result == control_result
    raise "unexpected result from '#{description}'"
  end
  result
end

@control = benchmark "conventional (eager)" do
  array.select { |x| x.even? }.collect { |x| x*x }
end

def can_require?(library)
  require(library)
  true
rescue LoadError
  false
end

if array.respond_to?(:lazy)

  benchmark "ruby2 Enumerable#lazy", @control do
    array.lazy.select { |x| x.even? }.lazy.collect { |x| x*x }
  end

elsif can_require?("backports/2.0.0/enumerable")

  benchmark "backports Enumerable#lazy", @control do
    array.lazy.select { |x| x.even? }.lazy.collect { |x| x*x }
  end

end

if can_require? "facets"

  benchmark "facets Enumerable#defer", @control do
    array.defer.select { |x| x.even? }.collect { |x| x*x }
  end

end

if defined?(Fiber) && can_require?("lazing")

  module Enumerable
    alias :lazing_select :selecting
    alias :lazing_collect :collecting
  end

  benchmark "lazing", @control do
    array.lazing_select { |x| x.even? }.lazing_collect { |x| x*x }
  end

end

if can_require?("enumerating")

  benchmark "enumerating", @control do
    array.selecting { |x| x.even? }.collecting { |x| x*x }
  end

end

if can_require?("lazily")

  benchmark "lazily", @control do
    array.lazily.select { |x| x.even? }.collect { |x| x*x }
  end

end

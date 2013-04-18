# -*- encoding: utf-8 -*-

$:.push File.expand_path("../lib", __FILE__)
require "lazily/version"

Gem::Specification.new do |s|

  s.name          = "lazily"
  s.version       = Lazily::VERSION.dup
  s.platform      = Gem::Platform::RUBY
  s.authors       = ["Mike Williams"]
  s.email         = "mdub@dogbiscuit.org"
  s.homepage      = "http://github.com/mdub/lazily"

  s.summary       = %{Lazy Enumerables for everybody!}
  s.description   = <<-EOT
    Lazily implements "lazy" versions of many Enumerable methods,
    allowing streamed processing of large (or even infinite) collections.

    It's equivalent to Ruby-2.x's Enumerable#lazy, but is implemented in
    pure Ruby, and works even in Ruby-1.8.x.
  EOT

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]

end

# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "capacity/version"

Gem::Specification.new do |s|
  s.name        = "capacity"
  s.version     = Capacity::VERSION
  s.authors     = ["Steve Rackham"]
  s.email       = ["steve@finerylondon.com"]
  s.homepage    = "https://github.com/finerylondon/capacity"
  s.summary     = "Load testing using Apache Benchmark"
  s.platform    =  Gem::Platform::RUBY
  s.description = <<-DESC
Load testing using Apache Benchmark - more to come
DESC

  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib"]

  s.add_runtime_dependency "colorize"
  s.add_development_dependency %w(rake yaml)
end

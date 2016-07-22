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
  s.description = <<-DESC
Load testing using Apache Benchmark
DESC

  # s.rubyforge_project = "abcrunch"

  s.files         = `git ls-files`.split("\n")
  # s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  # s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  # s.license       = "MIT"

  s.add_runtime_dependency "colorize"
end

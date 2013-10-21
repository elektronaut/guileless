# encoding: utf-8

$:.push File.expand_path("../lib", __FILE__)
require "guileless/version"

Gem::Specification.new do |s|
  s.name        = 'guileless'
  s.version     = Guileless::VERSION
  s.date        = '2013-10-20'
  s.summary     = "Naive HTML preprocessor"
  s.description = "Naive HTML preprocessor"
  s.authors     = ["Inge Jørgensen"]
  s.email       = 'inge@elektronaut.no'
  s.homepage    = 'http://github.com/elektronaut/guileless'
  s.license     = 'MIT'
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
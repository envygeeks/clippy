$:.unshift(File.expand_path("../lib", __FILE__))
require "clippy/version"

Gem::Specification.new do |spec|
  spec.files = %W(Readme.md License Rakefile Gemfile) + Dir["lib/**/*"]
  spec.description = "A utility to access the systems clipboard."
  spec.summary = "A utility to access the systems clipboard."
  spec.homepage = "https://github.com/envygeeks/clippy"
  spec.email = ["jordon@envygeeks.com"]
  spec.version = Clippy::VERSION
  spec.license = "MIT"
  spec.name = "clippy"
  spec.require_paths = ["lib"]
  spec.executables = ["clippy"]
  spec.authors = ["Jordon Bedwell"]

  spec.add_development_dependency("rspec", "~> 3.0")
  spec.add_development_dependency("envygeeks-coveralls", "~> 0.2")
  spec.add_development_dependency("luna-rspec-formatters", "~> 1.2")
end

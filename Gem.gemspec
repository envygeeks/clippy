$:.unshift(File.expand_path("../lib", __FILE__))
require "clippy/version"

Gem::Specification.new do |spec|
  spec.summary = "A utility to access the systems clipboard."
  spec.homepage = "https://github.com/envygeeks/clippy"
  spec.add_development_dependency("coveralls")
  spec.version = Clippy::VERSION
  spec.add_dependency("popen4")
  spec.license = "MIT"
  spec.name = "clippy"
  spec.require_paths = ["lib"]
  spec.executables = ["clippy"]
  spec.authors = ["Jordon Bedwell"]
  spec.email = ["envygeeks@gmail.com"]
  spec.add_development_dependency("rake")
  spec.add_development_dependency("simplecov")
  spec.add_development_dependency("guard-rspec")
  spec.add_development_dependency("luna-rspec-formatters")
  spec.description = "A utility to access the systems clipboard."
  spec.files = %W(Readme.md License Rakefile Gemfile) + Dir["lib/**/*"]

  if RUBY_PLATFORM =~ /mswin/
    spec.required_ruby_version = ">= 1.9.1"
  end
end

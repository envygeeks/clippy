$:.unshift(File.expand_path("../lib", __FILE__))
require "clippy/version"

Gem::Specification.new do |spec|
  spec.summary = "A utility to access the systems clipboard."
  spec.homepage = "https://github.com/envygeeks/clippy"
  spec.add_development_dependency("minitest")
  spec.version = Clippy::VERSION
  spec.license = "MIT"
  spec.name = "clippy"
  spec.require_paths = ["lib"]
  spec.executables = ["clippy"]
  spec.authors = ["Jordon Bedwell"]
  spec.email = ["envygeeks@gmail.com"]
  spec.add_development_dependency("rake")
  spec.add_development_dependency("guard-rspec")
  spec.add_development_dependency("guard-minitest")
  spec.description = "A utility to access the systems clipboard."
  spec.files = %W(Readme.md License Rakefile Gemfile) + Dir["lib/**/*"]

  if RUBY_PLATFORM =~ /mswin/
    spec.required_ruby_version = ">= 1.9.1"
  end
end

$:.unshift(File.expand_path("../lib", __FILE__))
require "clippy/version"

Gem::Specification.new do |spec|
  spec.files = %W(Readme.md License Rakefile Gemfile) + Dir["lib/**/*"]
  spec.description = "A utility to access the systems clipboard."
  spec.summary = "A utility to access the systems clipboard."
  spec.homepage = "https://github.com/envygeeks/clippy"
  spec.version = Clippy::VERSION
  spec.license = "MIT"
  spec.name = "clippy"
  spec.require_paths = ["lib"]
  spec.executables = ["clippy"]
  spec.authors = ["Jordon Bedwell"]
  spec.email = ["envygeeks@gmail.com"]

  # --------------------------------------------------------------------------
  # Dependencies.
  # --------------------------------------------------------------------------

  spec.add_development_dependency("rspec", "~> 2.14")
end

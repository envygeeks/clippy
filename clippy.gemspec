$:.unshift(File.expand_path("../lib", __FILE__))
require "clippy"

Gem::Specification.new do |spec|
  spec.license = "MIT"
  spec.name = "clippy"
  spec.has_rdoc = false
  spec.version = Clippy.version
  spec.require_paths = ["lib"]
  spec.executables = ["clippy"]
  spec.add_development_dependency("minitest")
  spec.add_development_dependency("pry")
  spec.add_development_dependency("rake")
  spec.add_development_dependency("simplecov")
  spec.authors = ["Jordon Bedwell"]
  spec.email = ["jordon@envygeeks.com"]
  spec.homepage = "https://github.com/envygeeks/clippy"
  spec.summary = "A utility to access the systems clipboard."
  spec.description = "A utility to access the systems clipboard."
  spec.files = Dir["**/*"]
  if RUBY_PLATFORM =~ /mswin/
    spec.required_ruby_version = '>= 1.9.1'
  end
end

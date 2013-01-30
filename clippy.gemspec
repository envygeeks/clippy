$:.unshift(File.expand_path("../lib", __FILE__))
require "clippy/version"

Gem::Specification.new do |spec|
  spec.version = Clippy::VERSION
  spec.license = "MIT"
  spec.name = "clippy"
  spec.has_rdoc = false
  spec.files = Dir["**/*"]
  spec.require_paths = ["lib"]
  spec.executables = ["clippy"]
  spec.authors = ["Jordon Bedwell"]
  spec.email = ["jordon@envygeeks.com"]
  spec.homepage = "https://github.com/envygeeks/clippy"
  spec.add_development_dependency("rake", "~> 10.0.3")
  spec.add_development_dependency("minitest", "~> 3.3.0")
  spec.summary = "A utility to access the systems clipboard."
  spec.description = "A utility to access the systems clipboard."

  if RUBY_PLATFORM =~ /mswin/
    spec.required_ruby_version = '>= 1.9.1'
  end
end

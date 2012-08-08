$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), 'lib')))
require 'clippy'

Gem::Specification.new do |spec|
  spec.license = 'MIT'
  spec.name = 'clippy'
  spec.has_rdoc = false
  spec.version = Clippy.version
  spec.require_paths = ['lib']
  spec.executables = ['clippy']
  spec.add_development_dependency('rspec-expectations')
  spec.add_development_dependency('rake')
  spec.add_development_dependency('minitest')
  spec.add_development_dependency('cucumber')
  spec.authors = ['Jordon Bedwell', 'Nathaniel Davidson']
  spec.email = ['jordon@envygeeks.com', 'nathaniel.davidson@gmail.com']
  spec.homepage = 'https://github.com/envygeeks/clippy'
  spec.summary = 'A utility to access the systems clipboard.'
  spec.description = 'A utility to access the systems clipboard.'
  spec.files = Dir.glob('lib/**/*') + Dir.glob('bin/**/*') + Dir.glob('test/**/*') + Dir.glob('features/**/*')
  spec.files+= %w(Readme.md License Rakefile Gemfile changelog.md)

  if RUBY_PLATFORM =~ /mswin/
    spec.required_ruby_version = '>= 1.9.1'
  end
end

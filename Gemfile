source 'https://rubygems.org'
gemspec

group :development do
  gem 'envygeeks-coveralls', :github => 'envygeeks/envygeeks-coveralls'
  gem 'luna-rspec-formatters'
  gem 'pry'

  # --------------------------------------------------------------------------
  # Shit for people who use Bundler with --path
  # --------------------------------------------------------------------------

  gem 'rake'

  # --------------------------------------------------------------------------
  # Stuff we don't want on the CI.
  # --------------------------------------------------------------------------

  unless ENV['CI']
    gem 'guard-rspec'
    gem 'listen', :github => 'envygeeks/listen'
  end
end

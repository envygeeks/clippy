source 'https://rubygems.org'
gemspec

group :development do
  gem 'envygeeks-coveralls', :github => 'envygeeks/envygeeks-coveralls'
  gem 'luna-rspec-formatters', '>= 0.0.1'

  unless ENV['CI']
    gem 'guard-rspec', '~> 3.0.2'
    gem 'listen', :github => 'envygeeks/listen'
  end
end

require_relative '../support/simplecov'
require 'luna/rspec/formatters/checks'
require 'securerandom'
require 'clippy'

Dir[File.expand_path('../../support/**/*.rb', __FILE__)].each do |f|
  require f
end

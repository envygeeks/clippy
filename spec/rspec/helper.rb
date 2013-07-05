require_relative '../support/simplecov'
require_relative '../support/format'
require 'securerandom'
require 'clippy'

Dir[File.expand_path('../../support/**/*.rb', __FILE__)].each do |f|
  require f
end

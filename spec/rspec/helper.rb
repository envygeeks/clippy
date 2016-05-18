require_relative "../support/coverage"
require "luna/rspec/formatters/checks"
require "clippy"

Dir[File.expand_path("../../support/**/*.rb", __FILE__)].each do |f|
  require f
end

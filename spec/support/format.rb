RSpec.configure do |config|
  if Gem::Specification.find_all_by_name('luna-rspec-formatters').any?
    require 'luna/rspec/formatters/checks'
    config.formatter = 'Luna::RSpec::Formatters::Checks'
  end
end

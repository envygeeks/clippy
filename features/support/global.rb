$:.unshift(File.join(File.dirname(__FILE__), '../../lib'))
require 'rspec/expectations'
require 'clippy'

RSpec::Matchers.define :be_defined do
  match do |defyned|
    defined? defyned
  end
end

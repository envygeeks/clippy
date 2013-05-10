#!/usr/bin/env ruby

guard :rspec do
  watch("spec/rspec/helper.rb") { "spec" }
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$}) { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^libs/(.+)\.rb$}) { |m| "spec/libs/#{m[1]}_spec.rb" }
end


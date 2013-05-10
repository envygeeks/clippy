task :default => [:test]
task :spec => :test
require "rake/testtask"
Rake::TestTask.new { |t| t.verbose, t.pattern = true, "tests/**/*.rb" }

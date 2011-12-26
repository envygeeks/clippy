require 'rubygems/package_task'
require 'rake/testtask'

Rake::TestTask.new do |tfile|
  tfile.verbose = true
  tfile.pattern = "tests/**/*.rb"
end

if ARGV.include?('features')
  require 'cucumber'
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:features)
end

Gem::PackageTask.new(eval(IO.read('clippy.gemspec'))) do |pkg|
  pkg.need_tar, pkg.need_zip = true
end

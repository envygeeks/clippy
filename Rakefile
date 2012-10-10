require "rubygems/package_task"
require "rake/testtask"

task :default => [:test]
task :spec => :test

Rake::TestTask.new do |tfile|
  tfile.verbose = true
  tfile.pattern = "tests/**/*.rb"
end

Gem::PackageTask.new(eval(IO.read("clippy.gemspec"))) do |pkg|
  pkg.need_tar, pkg.need_zip = true
end

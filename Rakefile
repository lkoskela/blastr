require "bundler/gem_tasks"
require "rake/testtask"

desc "Default: run tests."
task :default => :test

desc "Run unit tests"
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/test*.rb']
  t.verbose = false
end
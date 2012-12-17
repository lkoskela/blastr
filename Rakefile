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

ENCODING_HEADER = "# encoding: UTF-8"
desc "Add UTF-8 encoding to source files"
task :encoding do
  FileList['test/**/*.rb', 'lib/**/*.rb'].each do |filename|
    open(filename, 'r+') do |f|
      beginning_of_file = f.pos
      first_line = f.readline
      f.seek(beginning_of_file)
      original_content = f.read
      f.seek(beginning_of_file)
      unless first_line.strip == ENCODING_HEADER.strip
        puts "Adding '#{ENCODING_HEADER}' to #{filename}"
        f.write("#{ENCODING_HEADER}\n")
        f.write(original_content)
      end
    end
  end
end
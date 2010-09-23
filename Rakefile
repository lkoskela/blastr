require 'rubygems'
require 'hoe'
$:.unshift(File.dirname(__FILE__) + "/lib")
require File.expand_path(File.join(File.dirname(__FILE__), 'lib/blastr'))

# remember to try this with the next release
#Hoe.plugin :git

Hoe.spec 'blastr' do
  name = "blastr"
  developer('Lasse Koskela', 'lasse.koskela@gmail.com')
  description = "Blastr observes a version control repository for commits and makes audible announcements out of the commit messages."
  summary = "Blastr is an audible commit radiator"
  url = "http://github.com/lkoskela/blastr"
  clean_globs = ['test/output/*.png', '**/.DS_Store', 'tmp', '*.log']
  changes = paragraphs_of('History.txt', 0..1).join("\n\n")
  remote_rdoc_dir = '' # Release to root
  rsync_args = '-av --delete --ignore-errors'
  extra_deps = [
    ['git','>= 1.0.5'],
  ]
end

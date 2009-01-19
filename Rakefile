%w[rubygems rake rake/clean fileutils newgem rubigen].each { |f| require f }
require File.dirname(__FILE__) + '/lib/blastr'

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
$hoe = Hoe.new('blastr', Blastr::VERSION) do |p|
  p.developer('Lasse Koskela', 'lasse.koskela@gmail.com')
  p.changes              = p.paragraphs_of("History.txt", 0..1).join("\n\n")
  #p.post_install_message = 'PostInstall.txt' # TODO remove if post-install message not required
  p.rubyforge_name       = p.name
  p.extra_deps         = [
    ['git','>= 1.0.5'],
  ]
  #p.extra_dev_deps = [
  #  ['newgem', ">= #{::Newgem::VERSION}"]
  #]
  p.clean_globs |= %w[**/.DS_Store tmp *.log]
  path = (p.rubyforge_name == p.name) ? p.rubyforge_name : "\#{p.rubyforge_name}/\#{p.name}"
  #p.remote_rdoc_dir = File.join(path.gsub(/^#{p.rubyforge_name}\/?/,''), 'rdoc')
  p.remote_rdoc_dir = '' # Release to root
  p.rsync_args = '-av --delete --ignore-errors'
  p.bin_files = 'announce-svn-commits'
  #puts "Methods on p:\n  #{p.methods.sort.join(', ')}"
end

require 'newgem/tasks' # load /tasks/*.rake
Dir['tasks/**/*.rake'].each { |t| load t }

# TODO - want other tests/tasks run by default? Add them to the list
# task :default => [:spec, :features]

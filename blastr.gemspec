# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
#require File.expand_path(__FILE__, "lib/version.rb")

Gem::Specification.new do |s|
  s.name        = "blastr"
  s.version     = "1" #Blastr::VERSION
  s.authors     = ["Lasse Koskela"]
  s.email       = ["lasse.koskela@gmail.com"]
  s.homepage    = "http://github.com/lkoskela/blastr"
  s.summary     = %q{Blastr is an audible commit radiator}
  s.description = %q{Blastr observes a version control repository for commits and makes audible announcements out of the commit messages.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "mocha"
  s.add_runtime_dependency "git"
end

# encoding: UTF-8
require 'fileutils'
require File.expand_path(File.join(File.dirname(__FILE__), '../scm.rb'))
require File.expand_path(File.join(File.dirname(__FILE__), '../log_entry.rb'))
require File.expand_path(File.join(File.dirname(__FILE__), 'revision.rb'))

module Blastr::SourceControl
  
  class Mercurial
    def name; "Mercurial"; end

    def self.understands_url?(url)
      url.index("hg:") == 0
    end

    def initialize(repo_url)
      @repo_url = $1 if repo_url =~ /hg:(.*)/
    end

    def as_revision(arg)
      raise "Invalid revision: #{arg}" unless arg =~ /^(tip)|([\d\w:-]+)$/
      MercurialRevision.new(arg)
    end
  
    def latest_revision
      commits = commits_since(as_revision("tip"))
      return as_revision("tip") unless commits.size > 0
      MercurialRevision.new(commits.last.revision.to_s)
    end

    def commits_since(revision)
      with_clone do
        hg_log(revision.to_s)
      end
    end
    
    def hg_log_entries(output)
      entries = []
      current_changeset = {}
      output.split(/-{69,71}/).each do |entry|
        if entry =~ /^changeset (\d+):(.+) by (.+):\n(.*)/mu
          entries << LogEntry.new(as_revision($1), $3, $4.strip)
        end
      end
      entries
    end
    
    private

    def hg_log(revision = 0)
      separator = "-" * 70
      template = "\\nchangeset {rev}:{node} by {author}:\\n{desc}\\n#{separator}"
      output = %x[hg log -r '#{revision}:' --template '#{template}'].strip
      hg_log_entries(output)
    end
    
    def with_clone
      clone_dir = Blastr::FileSystem.temp_dir
      Blastr::FileSystem::delete_at_exit(clone_dir)
      %x[hg clone #{@repo_url} #{clone_dir}]
      current_dir = Dir.pwd
      Dir.chdir(clone_dir)
      begin
        yield
      ensure
        Dir.chdir(current_dir)
        FileUtils.remove_dir(clone_dir, :force => true)
      end
    end
  end

end

Blastr::SourceControl.register_implementation(Blastr::SourceControl::Mercurial)

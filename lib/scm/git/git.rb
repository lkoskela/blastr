# encoding: UTF-8
require 'git'
require File.expand_path(File.join(File.dirname(__FILE__), '../scm.rb'))
require File.expand_path(File.join(File.dirname(__FILE__), 'revision.rb'))
require File.expand_path(File.join(File.dirname(__FILE__), 'log_entry.rb'))

module Blastr::SourceControl
    
  class Git
    def name; "Git"; end

    def self.understands_url?(url)
      return true if local_repository?(url)
      patterns = [ /^(git:)(.*)$/, /^(.*)(\.git)(\/?)$/ ]
      patterns.each do |regex|
        return true if url =~ regex
      end
      false
    end

    def initialize(git_url)
      @git_url = git_url
    end
    
    def url
      @git_url
    end

    def as_revision(arg)
      raise "Invalid revision: #{arg}" unless arg =~ /^(HEAD(~\d+)?)|([\d\w:-]+)$/
      revision = nil
      with_clone do |clone|
        obj = clone.object(arg.to_s)
        revision = GitRevision.new(obj.sha, obj.date)
      end
      revision
    end
  
    def latest_revision
      commits = commits_since(as_revision("HEAD~1"))
      return as_revision("HEAD") unless commits.size > 0
      GitRevision.new(commits.last.revision.to_s, commits.last.revision.date)
    end

    def commits_since(revision)
      with_clone do |clone|
        commits = []
        clone.log.between(revision.to_s).each do |commit|
          commits << GitLogEntry.new(commit)
        end
        return commits.reverse
      end
    end
    
    private
    
    def self.local_repository?(path)
      path = path["file://".length..-1] if path.start_with? "file://"
      return false unless File.directory?(path)
      File.directory?(File.join(path, '.git'))
    end
    
    def with_clone
      temp_dir = Blastr::FileSystem.temp_dir
      Blastr::FileSystem.delete_at_exit(temp_dir)
      begin
        clone = ::Git.clone(@git_url, temp_dir)
        clone.chdir do
          yield clone
        end
      ensure
        FileUtils.rm_rf(temp_dir, :secure => true)
      end
    end
  end

end

Blastr::SourceControl.register_implementation(Blastr::SourceControl::Git)

require 'git'
require File.dirname(__FILE__) + '/scm.rb'

module Blastr::SourceControl
    
  class GitLogEntry < LogEntry
    def initialize(commit)
      @revision = GitRevision.new(commit.sha, commit.date)
      @author = commit.author.name
      @comment = commit.message
    end
  end

  class GitRevision
    attr_accessor :name, :date
    
    def initialize(name, date = Time.now)
      @name = name
      @date = date
    end
    
    def to_s
      @name
    end
    
    def before?(revision)
      return false if @name == "HEAD"
      return true if revision.name == "HEAD"
      return @date < revision.date unless @date.nil?
      @name < revision.name
    end
  end
    
  class Git
    def name; "Git"; end

    def self.understands_url?(url)
      patterns = [ /^(git:)(.*)$/, /^(.*)(\.git)(\/?)$/ ]
      patterns.each do |regex|
        return true if url =~ regex
      end
      false
    end

    def initialize(git_url)
      @git_url = git_url
    end

    def as_revision(arg)
      raise "Invalid revision: #{arg}" unless arg =~ /^(HEAD(~\d+)?)|([\d\w:-]+)$/
      obj = nil
      revision = nil
      with_clone do |clone|
        obj = clone.object(arg.to_s)
        revision = GitRevision.new(obj.sha, obj.date)
      end
      revision
    end
  
    def latest_revision
      commits = commits_since(as_revision("HEAD~5"))
      return as_revision("HEAD") unless commits.size > 0
      GitRevision.new(commits.last.revision.to_s)
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
    def with_clone
      temp_dir = Blastr::temp_dir
      Blastr::delete_at_exit(temp_dir)
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

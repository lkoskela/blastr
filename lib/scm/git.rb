require 'rubygems'
require 'git'
require 'blastr/scm.rb'

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
    
    def initialize(name, date = nil)
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
      url.index("git://") == 0
    end

    def initialize(git_url)
      @git_url = git_url
    end

    def as_revision(arg)
      raise "Invalid revision: #{arg}" unless arg =~ /^(HEAD(~\d+)?)|([\d\w:-]+)$/
      GitRevision.new(arg.to_s)
    end
  
    def latest_revision
      commits = commits_since(as_revision("HEAD~5"))
      return as_revision("HEAD") unless commits.size > 0
      GitRevision.new(commits.last.revision.to_s)
    end

    def commits_since(revision)
      @clone = ::Git.clone(@git_url, Blastr::temp_dir)
      begin
        @clone.chdir do
          commits = []
          @clone.log.between(revision.to_s).each do |commit|
            commits << GitLogEntry.new(commit)
          end
          return commits.reverse
        end
      ensure
        FileUtils.remove_dir(@clone.dir, :force => true)
      end
    end
  end

end

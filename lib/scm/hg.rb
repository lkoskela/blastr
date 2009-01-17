require 'fileutils'
require File.dirname(__FILE__) + '/scm.rb'

module Blastr::SourceControl
  
  class MercurialRevision
    attr_accessor :name
    
    def initialize(name)
      @name = name
    end
    
    def to_s
      @name
    end
    
    def before?(revision)
      return false if @name == "tip"
      return true if revision.name == "tip"
      @name.to_i < revision.name.to_i
    end
  end

  class Mercurial
    def name; "Mercurial"; end

    def self.understands_url?(url)
      url.index("hg:http") == 0
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
    
    private
    def hg_log(revision = 0)
      nonascii = /([^a-zA-Z0-9\.,:;\-_\?!"'\s]+?)/u
      entries = []
      current_changeset = {}
      %x[hg log -r #{revision}:].each_line do |line|
        if line =~ /^changeset:\s+(.+?):(.+?)$/
          entries << current_changeset unless current_changeset.empty?
          current_changeset = { :revision => $1, :hash => $2 }
        elsif line =~ /^user:\s+(.+?)(\s<(.+?)@(.+?)>)?$/
          current_changeset[:author] = $1
        elsif line =~ /^summary:\s+(.+?)$/
          current_changeset[:comment] = $1.strip
        elsif current_changeset.key? :comment
          current_changeset[:comment] = "#{current_changeset[:comment]} #{line.strip}"
        end
      end
      entries << current_changeset unless current_changeset.empty?
      
      entries.collect do |map|
        LogEntry.new(as_revision(map[:revision]), map[:author], map[:comment].gsub(nonascii, 'X '))
      end
    end
    
    def with_clone
      clone_dir = Blastr::temp_dir
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

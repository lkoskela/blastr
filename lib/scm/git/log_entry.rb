# encoding: UTF-8

require File.expand_path(File.join(File.dirname(__FILE__), '../log_entry.rb'))
require File.expand_path(File.join(File.dirname(__FILE__), 'revision.rb'))

module Blastr::SourceControl
    
  class GitLogEntry < LogEntry
    def initialize(commit)
      @revision = GitRevision.new(commit.sha, commit.date)
      @author = commit.author.name
      @comment = commit.message
    end
  end

end

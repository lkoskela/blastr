# encoding: UTF-8

module Blastr::SourceControl
  
  class LogEntry
    attr_accessor :revision, :author, :comment

    def initialize(revision, author, comment)
      @revision = revision
      @author = author
      @comment = comment
    end

    def ==(other)
      @revision == other.revision and @author == other.author and @comment == other.comment
    end

    def to_s
      "revision #{@revision} by #{@author}: #{@comment}"
    end
  end
  
end

module Blastr::SourceControl
  
  class LogEntry
    attr_accessor :revision, :author, :comment
    def initialize(revision, author, comment)
      @revision = revision
      @author = author
      @comment = comment
    end
    def to_s
      "revision #{@revision} by #{@author}: #{@comment}"
    end
  end
  
  def self.implementation_for(url)
    IMPLEMENTATIONS.each do |impl|
      if impl.understands_url?(url)
        return impl.new(url)
      end
    end
    raise "No SCM implementation found that would understand #{url}"
  end
  
  IMPLEMENTATIONS = []
  
  def self.register_implementation(implementation)
    IMPLEMENTATIONS << implementation unless IMPLEMENTATIONS.include?(implementation)
  end
  
end

require File.dirname(__FILE__) + '/svn.rb'
require File.dirname(__FILE__) + '/git.rb'

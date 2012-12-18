# encoding: UTF-8

module Blastr::SourceControl

  class GitRevision
    attr_accessor :name, :date
    
    def initialize(name, date)
      @name = name
      @date = date
      raise ArgumentError if date.nil? and name != "HEAD"
    end
    
    def to_s
      @name
    end
    
    def before?(revision)
      return false if @name == "HEAD"
      return true if revision.name == "HEAD"
      @date < revision.date
    end
    
    def self.head
      GitRevision.new("HEAD", nil)
    end
    
    def ==(other)
      return false unless other.is_a? GitRevision
      other.name == @name and other.date == @date
    end
  end

end

# encoding: UTF-8

module Blastr::SourceControl

  class SubversionRevision
    attr_accessor :name
    
    def initialize(name)
      @name = name
    end
    
    def to_s
      @name
    end
    
    def ==(other)
      @name == other.name
    end
    
    def before?(revision)
      return false if @name == "HEAD"
      return true if revision.name == "HEAD"
      @name.to_i < revision.name.to_i
    end
  end

end

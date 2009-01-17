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
    
end
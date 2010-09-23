require 'stringio'
require 'test/unit'
require File.dirname(__FILE__) + '/../lib/blastr'

class Test::Unit::TestCase
  # implement a declaration 'abstract' that can be used to make 
  # a Test::Unit::TestCase subclass abstract without getting 
  # complaints about not defining any tests.
  class << self
    def abstract
      self.class_eval do
        def test_default
        end
      end
    end
  end
end

require File.dirname(__FILE__) + '/abstract_scm_testcase.rb'

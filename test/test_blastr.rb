require File.dirname(__FILE__) + '/test_helper.rb'

class TestBlastrProcess < Test::Unit::TestCase
  def test_command_line_arguments_are_validated
    assert_raise Blastr::UsageError do
      Blastr::Process.new([])
    end
    assert_raise Blastr::UsageError do
      Blastr::Process.new(["http://svn.com", "123", "too-much"])
    end
    assert_nothing_raised do
      Blastr::Process.new(["http://svn.com", "123"])
    end
  end
end
require File.dirname(__FILE__) + '/test_helper.rb'

class TestLogEntry < Test::Unit::TestCase  
  def test_equality
    assert_equal create_log_entry, create_log_entry
    assert_not_equal create_log_entry(:revision => "1"), create_log_entry(:revision => "2")
    assert_not_equal create_log_entry(:author => "John"), create_log_entry(:author => "Jane")
    assert_not_equal create_log_entry(:comment => "Oh"), create_log_entry(:comment => "Yeah")
  end
  
  private
  def create_log_entry(args = {})
    defaults = { :revision => "rev", :author => "author", :comment => "comment" }
    args = defaults.update(args)
    Blastr::SourceControl::LogEntry.new(args[:revision], args[:author], args[:comment])
  end
end

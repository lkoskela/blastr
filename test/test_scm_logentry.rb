require File.dirname(__FILE__) + '/test_helper.rb'

class TestLogEntry < Test::Unit::TestCase  
  def test_equality
    assert_equal create_log_entry, create_log_entry
  end
  
  private
  def create_log_entry
    rev = Blastr::SourceControl::SubversionRevision.new("707")
    Blastr::SourceControl::LogEntry.new(rev, "author", "comment")
  end
end

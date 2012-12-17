require File.expand_path(File.join(File.dirname(__FILE__), '../test_helper.rb'))

class TestSubversionRevision < Test::Unit::TestCase

  def test_to_s
    rev = Blastr::SourceControl::SubversionRevision.new("123")
    assert rev.to_s == "123"
  end
  
  def test_equality_comparison
    assert_equal revision("123"), revision("123")
    assert revision("456") == revision("456")
  end

  def test_before_comparison_between_revisions
    rev123 = revision("123")
    rev456 = revision("456")
    assert rev123.before?(rev456) == true
    assert rev456.before?(rev123) == false
  end

  def test_before_comparison_with_HEAD
    rev = revision("100")
    head = revision("HEAD")
    assert rev.before?(head) == true
    assert head.before?(rev) == false
  end
  
  private
  def revision(value)
    Blastr::SourceControl::SubversionRevision.new(value)
  end
end

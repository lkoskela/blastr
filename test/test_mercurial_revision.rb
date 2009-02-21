require File.dirname(__FILE__) + '/test_helper.rb'

class TestMercurialRevision < Test::Unit::TestCase

  def test_to_s
    assert revision("123").to_s == "123"
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

  def test_before_comparison_with_tip
    rev = revision("100")
    tip = revision("tip")
    assert rev.before?(tip) == true
    assert tip.before?(rev) == false
  end
  
  private
  def revision(value)
    Blastr::SourceControl::MercurialRevision.new(value)
  end
end

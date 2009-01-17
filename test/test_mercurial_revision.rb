require File.dirname(__FILE__) + '/test_helper.rb'

class TestMercurialRevision < Test::Unit::TestCase

  def test_to_s
    rev = Blastr::SourceControl::MercurialRevision.new("123")
    assert rev.to_s == "123"
  end

  def test_before_comparison_between_revisions
    rev123 = Blastr::SourceControl::MercurialRevision.new("123")
    rev456 = Blastr::SourceControl::MercurialRevision.new("456")
    assert rev123.before?(rev456) == true
    assert rev456.before?(rev123) == false
  end

  def test_before_comparison_with_tip
    rev = Blastr::SourceControl::MercurialRevision.new("100")
    tip = Blastr::SourceControl::MercurialRevision.new("tip")
    assert rev.before?(tip) == true
    assert tip.before?(rev) == false
  end
end

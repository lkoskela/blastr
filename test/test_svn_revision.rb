require File.dirname(__FILE__) + '/test_helper.rb'

class TestSubversionRevision < Test::Unit::TestCase

  def test_to_s
    rev = Blastr::SubversionRevision.new("123")
    assert rev.to_s == "123"
  end

  def test_before_comparison_between_revisions
    rev123 = Blastr::SubversionRevision.new("123")
    rev456 = Blastr::SubversionRevision.new("456")
    assert rev123.before?(rev456) == true
    assert rev456.before?(rev123) == false
  end

  def test_before_comparison_with_HEAD
    rev = Blastr::SubversionRevision.new("100")
    head = Blastr::SubversionRevision.new("HEAD")
    assert rev.before?(head) == true
    assert head.before?(rev) == false
  end
end

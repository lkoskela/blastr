require File.dirname(__FILE__) + '/test_helper.rb'

class TestGitRevision < Test::Unit::TestCase
  
  SAMPLE_SHA = "db4ace1c9ba6add9a2b08c153367e2b379f8fb4c"
  
  def setup
    @revision_with_date = Blastr::SourceControl::GitRevision.new(SAMPLE_SHA, Time.now)
    @revision_without_date = Blastr::SourceControl::GitRevision.new(SAMPLE_SHA)
  end

  def test_to_s
    assert @revision_without_date.to_s == SAMPLE_SHA
    assert @revision_with_date.to_s == SAMPLE_SHA
  end

  def test_before_comparison_between_dated_revisions
    later_revision = Blastr::SourceControl::GitRevision.new(SAMPLE_SHA, @revision_with_date.date + 1)
    assert @revision_with_date.before?(later_revision) == true
    assert later_revision.before?(@revision_with_date) == false
  end

  def test_before_comparison_with_HEAD
    head = Blastr::SourceControl::GitRevision.new("HEAD")
    [@revision_with_date, @revision_without_date].each do |any_revision|
      assert any_revision.before?(head) == true
      assert head.before?(any_revision) == false
    end
  end
end

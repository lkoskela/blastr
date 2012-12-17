# encoding: UTF-8
require File.expand_path(File.join(File.dirname(__FILE__), '../test_helper.rb'))

class TestGitRevision < Test::Unit::TestCase
  
  SAMPLE_SHA = "db4ace1c9ba6add9a2b08c153367e2b379f8fb4c"
  
  def setup
    @revision = Blastr::SourceControl::GitRevision.new(SAMPLE_SHA, Time.now - 100)
  end

  def test_to_s_prints_the_sha_hash
    assert @revision.to_s == SAMPLE_SHA
  end

  def test_before_comparison_between_revisions
    later_revision = Blastr::SourceControl::GitRevision.new(SAMPLE_SHA, @revision.date + 1)
    assert @revision.before?(later_revision) == true
    assert later_revision.before?(@revision) == false
  end

  def test_before_comparison_with_HEAD
    head = Blastr::SourceControl::GitRevision.head
    assert @revision.before?(head) == true
    assert head.before?(@revision) == false
  end
  
  def test_only_HEAD_can_be_created_with_nil_date
    assert_raise ArgumentError do
      Blastr::SourceControl::GitRevision.new(SAMPLE_SHA, nil)
    end
    assert_nothing_raised do
      Blastr::SourceControl::GitRevision.new("HEAD", nil)
    end
  end
end

# encoding: UTF-8
require File.expand_path(File.join(File.dirname(__FILE__), '../test_helper.rb'))

class TestMercurial < AbstractScmTestCase

  MERCURIAL_URLS = [ 
    "hg:http://foo.com/hg", 
    "hg:http://foo.com/hg/", 
    "hg:/tmp/hg/repo",
    "hg:/tmp/hg/repo/" ]
  
  def test_mercurial_urls
    assert_urls_are_understood(MERCURIAL_URLS)
  end
  
  def test_non_mercurial_urls
    assert_urls_are_not_understood(["http://acme.com/foo"])
  end
  
  def test_detects_latest_revision_from_commit_log
    repo = scm.new("hg:/fakerepo")
    repo.expects(:commits_since).with(revision("tip")).returns([
      logentry(revision("15"), "author", "comment")
    ])
    assert_equal revision("15"), repo.latest_revision
  end
  
  def test_latest_revision_for_empty_log_defaults_to_revision_1
    repo = scm.new("hg:/fakerepo")
    repo.expects(:commits_since).with(revision("tip")).returns([])
    assert_equal revision("tip"), repo.latest_revision
  end
  
  private

  def scm
    Blastr::SourceControl::Mercurial
  end
  
  def logentry(revision, author = "johndoe", comment = "Small fix")
    Blastr::SourceControl::LogEntry.new(revision, author, comment)
  end
  
  def revision(value)
    Blastr::SourceControl::MercurialRevision.new(value)
  end

end
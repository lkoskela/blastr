require File.dirname(__FILE__) + '/test_helper.rb'

class TestScmURLMatching < Test::Unit::TestCase

  GIT_URLS = [
    "git://foo.com/bar.git",
    "git:/path/to/repo",
    "git:http://repo.com/project",
    "http://github.com/user/project.git",
    "http://github.com/user/project.git/",
    "https://github.com/user/project.git",
    "rsync://host.xz/repo.git",
    "rsync://host.xz/repo.git/",
    "ssh://host.xz/repo.git/",
    "host.xz/repo.git",
    "host.xz/repo.git/",
    "user@host.xz/repo.git",
    "user@host.xz/repo.git/",
    "ssh://user@host.xz/repo.git/",
    "ssh://user@host.xz:1234/path/to/repo.git",
    "file:///path/to/local/repo.git",
    "file:///path/to/local/repo.git/",
    "/path/to/repo.git",
    "/path/to/repo.git/" ]
  MERCURIAL_URLS = [ 
    "hg:http://foo.com/hg", 
    "hg:http://foo.com/hg/", 
    "hg:/tmp/hg/repo",
    "hg:/tmp/hg/repo/" ]
  SVN_URLS = [
    "http://foo.com/repo",
    "http://foo.com/repo/",
    "https://foo.com/repo",
    "https://foo.com/repo/",
    "svn:http://foo.com/svn",
    "svn:http://foo.com/svn/",
    "svn:https://foo.com/svn",
    "svn://foo.com/svn" ]
  
  def test_subversion
    assert_urls_are_understood_by(Blastr::SourceControl::Subversion, SVN_URLS)
  end

  def test_git
    assert_urls_are_understood_by(Blastr::SourceControl::Git, GIT_URLS)
  end

  def test_mercurial
    assert_urls_are_understood_by(Blastr::SourceControl::Mercurial, MERCURIAL_URLS)
  end
  
  private
  def assert_urls_are_understood_by(scm, list_of_urls)
    list_of_urls.each do |url|
      assert scm.understands_url?(url), "#{url} should be understood by #{scm}!"
    end
  end
end
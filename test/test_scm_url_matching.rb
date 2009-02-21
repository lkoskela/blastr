require File.dirname(__FILE__) + '/test_helper.rb'

class TestScmURLMatching < Test::Unit::TestCase

  GIT_URLS = [ "git://foo.com/bar.git" ]
  MERCURIAL_URLS = [ "hg:http://foo.com/hg", "hg:/tmp/hg/repo" ]
  SVN_URLS = [ "http://foo.com/svn", "https://foo.com/svn", "svn://foo.com/svn" ]
  ALL_URLS = [ SVN_URLS, GIT_URLS, MERCURIAL_URLS ].flatten
  
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
    ALL_URLS.reject {|url| list_of_urls.include?(url) }.each do |url|
      assert scm.understands_url?(url) == false, "#{url} should not be understood by #{scm}!"
    end
  end
end
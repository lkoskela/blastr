require File.dirname(__FILE__) + '/test_helper.rb'

class TestScmURLMatching < Test::Unit::TestCase
  GIT_URL = "git://foo.com/bar.git"
  MERCURIAL_URL = "hg:http://foo.com/svn"
  SVN_HTTP_URL = "http://foo.com/svn"
  SVN_HTTPS_URL = "https://foo.com/svn"
  SVN_NATIVE_URL = "svn://foo.com/svn"
  SVN_URLS = [ SVN_HTTP_URL, SVN_HTTPS_URL, SVN_NATIVE_URL ]
  ALL_URLS = [ SVN_URLS, GIT_URL, MERCURIAL_URL ].flatten
  
  def test_subversion
    SVN_URLS.each do |url|
      assert Blastr::SourceControl::Subversion.understands_url?(url), "#{url} should be a Subversion URL!"
    end
    ALL_URLS.reject {|url| SVN_URLS.include?(url) }.each do |url|
      assert Blastr::SourceControl::Subversion.understands_url?(url) == false, "#{url} should not be a Subversion URL!"
    end
  end

  def test_git
    assert Blastr::SourceControl::Git.understands_url?(GIT_URL)
    ALL_URLS.reject {|url| url == GIT_URL }.each do |url|
      assert Blastr::SourceControl::Git.understands_url?(url) == false, "#{url} should not be a Git URL!"
    end
  end

  def test_mercurial
    assert Blastr::SourceControl::Mercurial.understands_url?(MERCURIAL_URL)
    ALL_URLS.reject {|url| url == MERCURIAL_URL }.each do |url|
      assert Blastr::SourceControl::Mercurial.understands_url?(url) == false, "#{url} should not be a Mercurial URL!"
    end
  end
end
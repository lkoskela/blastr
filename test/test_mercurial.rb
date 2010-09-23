require File.dirname(__FILE__) + '/test_helper.rb'

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
  
  def scm
    Blastr::SourceControl::Mercurial
  end

end
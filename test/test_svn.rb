require File.dirname(__FILE__) + '/test_helper.rb'

class TestSubversion < Test::Unit::TestCase
  def test_knows_its_url
    url = "file:///repo"
    assert_equal url, Blastr::SourceControl::Subversion.new(url).url
  end
  
  def test_local_repository_urls_enforce_the_file_scheme
    repo = Blastr::SourceControl::Subversion.new("/repo")
    assert_equal "file:///repo", repo.url
  end
end
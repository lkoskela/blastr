require File.dirname(__FILE__) + '/test_helper.rb'

class TestGit < Test::Unit::TestCase

  def test_knows_its_url
    urls = [ "/repo", "file:///repo", "git://github.com/user/repo.git" ]
    urls.each do |url|
      assert_equal url, Blastr::SourceControl::Git.new(url).url
    end
  end

end
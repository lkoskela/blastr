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
  
  def setup
    @local_svn_repo = File.join(Blastr::temp_dir, 'svn_repo')
    FileUtils.mkdir_p(@local_svn_repo)
    %x[svnadmin create #{@local_svn_repo}]
    assert File.directory? @local_svn_repo
  end
  
  def teardown
    FileUtils.rm_rf(@local_svn_repo)
  end
  
  def test_local_subversion_repository
    local_repositories = [ @local_svn_repo, "file://#{@local_svn_repo}"]
    assert_urls_are_understood_by(Blastr::SourceControl::Subversion, local_repositories)
  end
  
  def test_subversion_doesnt_claim_to_understand_a_local_non_repository_directory
    assert_equal false, Blastr::SourceControl::Subversion.understands_url?(File.dirname(@local_svn_repo))
  end
  
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
require File.dirname(__FILE__) + '/test_helper.rb'

class TestSubversion < AbstractScmTestCase

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
    @local_svn_repo = create_local_svn_repo
  end
  
  def teardown
    FileUtils.rm_rf(@local_svn_repo)
  end

  def test_knows_its_url
    url = "file:///repo"
    assert_equal url, scm.new(url).url
  end
  
  def test_local_repository_urls_enforce_the_file_scheme
    repo = scm.new("/repo")
    assert_equal "file:///repo", repo.url
  end
  
  def test_local_subversion_repository
    local_repositories = [ @local_svn_repo, "file://#{@local_svn_repo}"]
    assert_urls_are_understood(local_repositories)
  end
  
  def test_subversion_doesnt_claim_to_understand_a_local_non_repository_directory
    assert_equal false, scm.understands_url?(File.dirname(@local_svn_repo))
  end
  
  def test_subversion
    assert_urls_are_understood(SVN_URLS)
  end

  private
  
  def scm
    Blastr::SourceControl::Subversion
  end
  
  def create_local_svn_repo
    local_svn_repo = File.join(Blastr::temp_dir, 'svn_repo')
    %x[svnadmin create #{local_svn_repo}]
    assert File.directory? local_svn_repo
    local_svn_repo
  end

end
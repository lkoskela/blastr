# encoding: UTF-8
require File.expand_path(File.join(File.dirname(__FILE__), '../test_helper.rb'))

class TestGit < AbstractScmTestCase

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

  def setup
    @local_repo = create_local_repo
  end

  def teardown
    FileUtils.rm_rf(@local_repo)
  end

  def test_knows_its_url
    urls = [ "/repo", "file:///repo", "git://github.com/user/repo.git" ]
    urls.each do |url|
      assert_equal url, Blastr::SourceControl::Git.new(url).url
    end
  end

  def test_git
    assert_urls_are_understood(GIT_URLS)
  end
  
  def test_local_repository
    local_repositories = [ @local_repo, "file://#{@local_repo}"]
    assert_urls_are_understood(local_repositories)
  end
  
  def test_git_doesnt_claim_to_understand_a_local_non_repository_directory
    parent_of_git_repo = File.dirname(@local_repo)
    assert_urls_are_not_understood([ parent_of_git_repo ])
  end
  
  def test_detects_latest_revision_from_commit_log
    latest_commit_sha = "LaT35tR3v1510N"
    head_minus_one = revision("HEAD~1")
    repo = scm.new("file:///fakerepo")
    repo.expects(:as_revision).with("HEAD~1").returns(head_minus_one)
    repo.expects(:commits_since).with(head_minus_one).returns([
      logentry(commit(latest_commit_sha))
    ])
    assert_equal revision(latest_commit_sha), repo.latest_revision
  end
  
  def test_latest_revision_for_empty_log_defaults_to_revision_1
    head = revision("HEAD")
    head_minus_one = revision("HEAD~1")
    repo = scm.new("file:///fakerepo")
    repo.expects(:as_revision).with("HEAD~1").returns(head_minus_one)
    repo.expects(:as_revision).with("HEAD").returns(head)
    repo.expects(:commits_since).with(head_minus_one).returns([])
    assert_equal head, repo.latest_revision
  end

  private
  
  def create_local_repo
    dir = File.join(Blastr::FileSystem.temp_dir, 'git_repo')
    %x[git init #{dir}]
    assert File.directory? dir
    dir
  end
  
  def commit(sha, options = {})
    defaults = { :date => "FAKE DATE", :author => stub(:name => "author"), :message => "message" }
    commit_data = defaults.merge(options.merge(:sha => sha))
    stub(commit_data)
  end
  
  def logentry(commit)
    Blastr::SourceControl::GitLogEntry.new(commit)
  end
  
  def revision(sha, date = "FAKE DATE")
    Blastr::SourceControl::GitRevision.new(sha, date)
  end

  def scm
    Blastr::SourceControl::Git
  end
end
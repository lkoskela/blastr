require File.dirname(__FILE__) + '/test_helper.rb'

class TestGitLogEntry < Test::Unit::TestCase
  COMMIT_HASH = "db4ace1c9ba6add9a2b08c153367e2b379f8fb4c"
  COMMIT_DATE = Time.now
  COMMIT_AUTHOR = "johndoe"
  COMMIT_MESSAGE = "o hai"
  
  class FakeAuthor
    def initialize(name); @name = name; end
    def name; @name; end
  end
  
  class FakeCommit
    def sha; COMMIT_HASH; end
    def date; COMMIT_DATE; end
    def author; FakeAuthor.new(COMMIT_AUTHOR); end
    def message; COMMIT_MESSAGE; end
  end
  
  def test_initialization
    entry = Blastr::SourceControl::GitLogEntry.new(FakeCommit.new)
    assert_equal Blastr::SourceControl::GitRevision, entry.revision.class
    assert_equal COMMIT_HASH, entry.revision.to_s
    assert_equal COMMIT_DATE, entry.revision.date
    assert_equal COMMIT_AUTHOR, entry.author
    assert_equal COMMIT_MESSAGE, entry.comment
  end
end
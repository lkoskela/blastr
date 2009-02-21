require File.dirname(__FILE__) + '/test_helper.rb'

class TestSubversionLogParsing < Test::Unit::TestCase
  
  def setup
    @svn = Blastr::SourceControl::Subversion.new("svn://whatever")
  end

  def test_one_entry
    log = <<EOS
------------------------------------------------------------------------
r123 | username | 2009-01-21 09:02:37 +0200 (Wed, 21 Jan 2009) | 1 line

The commit message goes here
------------------------------------------------------------------------
EOS
    entries = @svn.svn_log_entries(log)
    assert_equal [ Blastr::SourceControl::LogEntry.new(Blastr::SourceControl::SubversionRevision.new("123"), "username", "The commit message goes here") ], entries
  end

  def test_multiple_entries
    log = <<EOS
------------------------------------------------------------------------
r2 | janedoe | 2009-01-22 09:02:00 +0200 (Wed, 21 Jan 2009) | 1 line

Second revision
------------------------------------------------------------------------
r1 | johndoe | 2009-01-21 09:03:00 +0200 (Wed, 21 Jan 2009) | 1 line

First revision
------------------------------------------------------------------------
EOS
    actual_entries = @svn.svn_log_entries(log)
    expected_entries = [
      create_entry("2", "janedoe", "Second revision"),
      create_entry("1", "johndoe", "First revision")
      ]
    assert_equal expected_entries, actual_entries
  end

  def test_one_multiline_entry
    log = <<EOS
------------------------------------------------------------------------
r123 | username | 2009-01-21 09:02:37 +0200 (Wed, 21 Jan 2009) | 1 line

First line
Second line
Third line
------------------------------------------------------------------------
EOS
      entries = @svn.svn_log_entries(log)
      assert_equal [ create_entry("123", "username", "First line\nSecond line\nThird line") ], entries
  end


  def test_multiple_multiline_entries
    log = <<EOS
------------------------------------------------------------------------
r2 | bob | 2009-01-21 09:02:00 +0200 (Wed, 21 Jan 2009) | 1 line

First line of r2
Second line of r2
------------------------------------------------------------------------
r1 | alf | 2009-01-21 09:01:00 +0200 (Wed, 21 Jan 2009) | 1 line

First line of r1
Second line of r1
------------------------------------------------------------------------
EOS
        entries = @svn.svn_log_entries(log)
        assert_equal [ create_entry("2", "bob", "First line of r2\nSecond line of r2"),
                       create_entry("1", "alf", "First line of r1\nSecond line of r1") ], entries
    end
  
  private
  def create_entry(rev_string, author, comment)
    revision = Blastr::SourceControl::SubversionRevision.new(rev_string)
    Blastr::SourceControl::LogEntry.new(revision, author, comment)
  end
end

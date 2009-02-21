require File.dirname(__FILE__) + '/test_helper.rb'

class TestSubversionLogParsing < Test::Unit::TestCase
  
  def setup
    @svn = Blastr::SourceControl::Subversion.new("svn://whatever")
  end

  def test_one_entry
    @log = <<EOS
------------------------------------------------------------------------
r123 | username | 2009-01-21 09:02:37 +0200 (Wed, 21 Jan 2009) | 1 line

The commit message goes here
------------------------------------------------------------------------
EOS
    should_produce_entries [
      create_entry("123", "username", "The commit message goes here")
    ]
  end

  def test_multiple_entries
    @log = <<EOS
------------------------------------------------------------------------
r2 | janedoe | 2009-01-22 09:02:00 +0200 (Wed, 21 Jan 2009) | 1 line

Second revision
------------------------------------------------------------------------
r1 | johndoe | 2009-01-21 09:03:00 +0200 (Wed, 21 Jan 2009) | 1 line

First revision
------------------------------------------------------------------------
EOS
    should_produce_entries [
      create_entry("2", "janedoe", "Second revision"),
      create_entry("1", "johndoe", "First revision")
    ]
  end

  def test_one_multiline_entry
    @log = <<EOS
------------------------------------------------------------------------
r123 | username | 2009-01-21 09:02:37 +0200 (Wed, 21 Jan 2009) | 1 line

First line
Second line
Third line
------------------------------------------------------------------------
EOS
    should_produce_entries [
      create_entry("123", "username", "First line\nSecond line\nThird line")
    ]
  end

  def test_multiple_multiline_entries
    @log = <<EOS
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
    should_produce_entries [
      create_entry("2", "bob", "First line of r2\nSecond line of r2"),
      create_entry("1", "alf", "First line of r1\nSecond line of r1")
    ]
  end

  def test_special_characters_in_commit_message
    @log = <<EOS
------------------------------------------------------------------------
r3 | cat | 2009-01-21 09:03:00 +0200 (Wed, 21 Jan 2009) | 1 line

Revision 3
------------------------------------------------------------------------
r2 | bob | 2009-01-21 09:02:00 +0200 (Wed, 21 Jan 2009) | 1 line

Revision 2 with special ö character
------------------------------------------------------------------------
r1 | alf | 2009-01-21 09:01:00 +0200 (Wed, 21 Jan 2009) | 1 line

Revision 1
------------------------------------------------------------------------
EOS
    should_produce_entries [
      create_entry("3", "cat", "Revision 3"),
      create_entry("2", "bob", "Revision 2 with special ö character"),
      create_entry("1", "alf", "Revision 1")
    ]
  end
  
  private
  
  def should_produce_entries(expected_entries)
    assert_equal expected_entries, @svn.svn_log_entries(@log)
  end
  
  def create_entry(rev_string, author, comment)
    revision = Blastr::SourceControl::SubversionRevision.new(rev_string)
    Blastr::SourceControl::LogEntry.new(revision, author, comment)
  end
end

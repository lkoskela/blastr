# encoding: UTF-8
require File.expand_path(File.join(File.dirname(__FILE__), '../test_helper.rb'))

class TestMercurialLogParsing < Test::Unit::TestCase
  
  def setup
    @hg = Blastr::SourceControl::Mercurial.new("hg:http://whatever")
  end
  
  def test_no_entries
    @log = "----------------------------------------------------------------------\n"
    should_produce_entries []
  end

  def test_one_entry
    @log = <<EOS
changeset 24:e8a2a4d187773a62f3309b0fa265c13425bc2258 by username:
This is the commit message
----------------------------------------------------------------------
EOS
    should_produce_entries [ create_entry("24", "username", "This is the commit message") ]
  end

  def test_multiple_entries
    @log = <<EOS
changeset 10:e8a2a4d187773a62f3309b0fa265c13425bc2258 by alf:
Revision 10
----------------------------------------------------------------------
changeset 9:d7744e86dedc21a8ecf6bdb73eb191b8eaf5b0da by bob:
Revision 9
----------------------------------------------------------------------
changeset 8:4ae9f4bfdb98f65bd957e3fe72471b320150b38e by alf:
Revision 8
----------------------------------------------------------------------
EOS
    should_produce_entries [
      create_entry("10", "alf", "Revision 10"),
      create_entry("9", "bob", "Revision 9"),
      create_entry("8", "alf", "Revision 8") ]
  end

  def test_special_characters_in_commit_message
    @log = <<EOS
changeset 10:e8a2a4d187773a62f3309b0fa265c13425bc2258 by cat:
Revision 10
----------------------------------------------------------------------
changeset 9:d7744e86dedc21a8ecf6bdb73eb191b8eaf5b0da by bob:
Revision 9 with special ä and ö characters
----------------------------------------------------------------------
changeset 8:4ae9f4bfdb98f65bd957e3fe72471b320150b38e by alf:
Revision 8
----------------------------------------------------------------------
EOS
    should_produce_entries [
      create_entry("10", "cat", "Revision 10"),
      create_entry("9", "bob", "Revision 9 with special ä and ö characters"),
      create_entry("8", "alf", "Revision 8") ]
  end

  def test_dashes_in_the_commit_message
    @log = <<EOS
changeset 123:e8a2a4d187773a62f3309b0fa265c13425bc2258 by ohair:
   ---
-----
-
- Bullet
----------------------------------------------------------------------
EOS
    should_produce_entries [ create_entry("123", "ohair", "---\n-----\n-\n- Bullet") ]
  end

  def test_multiple_multiline_entries_with_empty_lines_within_commit_message
    @log = <<EOS
changeset 2:e8a2a4d187773a62f3309b0fa265c13425bc2258 by cat:
--
----------------------------------------------------------------------
changeset 1:d7744e86dedc21a8ecf6bdb73eb191b8eaf5b0da by bob:
-
----------------------------------------------------------------------
changeset 0:4ae9f4bfdb98f65bd957e3fe72471b320150b38e by alf:

----------------------------------------------------------------------
EOS
    should_produce_entries [
      create_entry("2", "cat", "--"),
      create_entry("1", "bob", "-"),
      create_entry("0", "alf", "") ]
  end
  
  private
  
  def should_produce_entries(expected_entries)
    assert_equal expected_entries, @hg.hg_log_entries(@log)
  end

  def create_entry(rev_string, author, comment)
    revision = Blastr::SourceControl::MercurialRevision.new(rev_string)
    Blastr::SourceControl::LogEntry.new(revision, author, comment)
  end
end

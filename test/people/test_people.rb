require File.expand_path(File.join(File.dirname(__FILE__), '../test_helper.rb'))
require 'fileutils'

class TestPeopleFile < Test::Unit::TestCase
  def setup
    backup_people_file
  end
  
  def teardown
    restore_people_file
  end
  
  def test_with_missing_people_file
    FileUtils.rm(Blastr::People::PEOPLE_FILE)
    assert_equal({}, Blastr::People.people)
    assert_equal "nick", Blastr::People.full_name_of("nick")
  end
  
  def test_with_existing_people_file
    open(Blastr::People::PEOPLE_FILE, 'w') do |f|
      f << "nick: Full Name\n"
      f << "name: In Full"
    end
    assert_equal({"nick" => "Full Name", "name" => "In Full"}, Blastr::People.people)
    assert_equal "Full Name", Blastr::People.full_name_of("nick")
  end
  
  private
  def backup_people_file
    people_file = Blastr::People::PEOPLE_FILE
    @backup_of_people_file = File.join(Blastr::FileSystem.temp_dir, File.basename(people_file))
    FileUtils.cp(people_file, @backup_of_people_file)
  end
  def restore_people_file
    FileUtils.cp(@backup_of_people_file, Blastr::People::PEOPLE_FILE)
  end
end
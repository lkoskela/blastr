# encoding: UTF-8
require File.expand_path(File.join(File.dirname(__FILE__), '../test_helper.rb'))
require 'fileutils'

class TestPeopleFile < Test::Unit::TestCase
  def setup
    create_blastr_directory
    backup_people_file
  end
  
  def teardown
    restore_people_file
  end
  
  def test_should_handle_missing_people_file_parent_directory
    parent_dir = File.dirname(Blastr::People::PEOPLE_FILE)
    FileUtils.rm_r(parent_dir)
    assert_equal({}, Blastr::People.people)
  end
  
  def test_should_handle_missing_people_file
    FileUtils.rm(Blastr::People::PEOPLE_FILE)
    assert_equal({}, Blastr::People.people)
    assert_equal "nick", Blastr::People.full_name_of("nick")
  end
  
  def test_should_use_existing_names_from_people_file
    open(Blastr::People::PEOPLE_FILE, 'w') do |f|
      f << "nick: Full Name\n"
      f << "name: In Full"
    end
    assert_equal({"nick" => "Full Name", "name" => "In Full"}, Blastr::People.people)
    assert_equal "Full Name", Blastr::People.full_name_of("nick")
    assert_equal "hot5hot", Blastr::People.full_name_of("hot5hot")
  end
  
  private
  
  def create_blastr_directory
    FileUtils.mkdir_p(File.dirname(Blastr::People::PEOPLE_FILE))
  end

  def backup_people_file
    people_file = Blastr::People::PEOPLE_FILE
    return unless File.exist?(people_file)
    @backup_of_people_file = File.join(Blastr::FileSystem.temp_dir, File.basename(people_file))
    FileUtils.cp(people_file, @backup_of_people_file)
  end

  def restore_people_file
    return unless File.exist?(@backup_of_people_file)
    create_blastr_directory
    FileUtils.cp(@backup_of_people_file, Blastr::People::PEOPLE_FILE)
  end
end
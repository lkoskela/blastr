# encoding: UTF-8
require 'yaml'

module Blastr
  class People
    PEOPLE_FILE = File.expand_path("~/.blastr/people")
    CONFIG_HELP_MESSAGE = <<EOS

If you'd like Blastr to pronounce committers' real names instead of their
UNIX names, you can create a YAML configuration file at

    #{PEOPLE_FILE}

The file format is like this:

johndoe: John Doe
janedoe: Jane Doe
jimbo: James Ruby

EOS
    
    puts CONFIG_HELP_MESSAGE unless File.file?(PEOPLE_FILE)
    
    def self.people
      if File.file?(PEOPLE_FILE)
        yaml = YAML.load_file(PEOPLE_FILE)
        return yaml unless yaml == false
      end
      { }
    end

    def self.full_name_of(username)
      people[username] ||= username
    end
  end
end

require 'yaml'

module Blastr
  class People
    PEOPLE_FILE = File.expand_path("~/.blastr/people")
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

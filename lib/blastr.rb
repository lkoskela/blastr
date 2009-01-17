$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'yaml'
require 'scm/git.rb'
require 'scm/svn.rb'
require 'tts/tts.rb'

module Blastr
  VERSION = '0.0.6'
  
  class Author
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
  
  class Process
    def initialize(args=[])
      scm_url = ARGV[0]
      @scm = Blastr.scm(scm_url)
      @since_revision = @scm.as_revision(ARGV[1]) if ARGV.size > 1
      @since_revision = @scm.latest_revision unless ARGV.size > 1
    end

    def announce(commit)
      puts "[#{commit.revision}] Commit by #{commit.author}: #{commit.comment}"
      Blastr::TTS.speak("Commit by #{Author.full_name_of(commit.author)}: #{commit.comment}")
    end
    
    def run
      puts "Polling #{@scm.name} commits since revision #{@since_revision}..."
      while true
        @scm.commits_since(@since_revision.to_s).each do |commit|
          if @since_revision.before?(commit.revision)
            announce(commit)
            @since_revision = commit.revision
          end
        end
        sleep 30
      end
    end
  end
  
  def Blastr::temp_dir
    temp_file = Tempfile.new("tmp")
    temp_dir = temp_file.path
    temp_file.unlink
    temp_dir
  end

  def Blastr::scm_implementations
    [ Blastr::Subversion, Blastr::Git ]
  end

  def Blastr::scm(url)
    scm_implementations.each do |impl|
      if impl.understands_url?(url)
        return impl.new(url)
      end
    end
    raise "No SCM implementation found that would understand #{url}"
  end
end

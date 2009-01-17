$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Blastr
  require 'scm/scm.rb'
  require 'tts/tts.rb'
  require 'people/people.rb'

  VERSION = '0.0.7'

  class Process
    def initialize(args=[])
      scm_url = ARGV[0]
      @scm = Blastr::SourceControl.implementation_for(scm_url)
      @since_revision = @scm.as_revision(ARGV[1]) if ARGV.size > 1
      @since_revision = @scm.latest_revision unless ARGV.size > 1
    end

    def run
      puts "Polling #{@scm.name} commits since revision #{@since_revision}..."
      while true
        announce_new_commits
        sleep 30
      end
    end
    
    def announce(commit)
      puts "[#{commit.revision}] Commit by #{commit.author}: #{commit.comment}"
      Blastr::TTS.speak("Commit by #{People.full_name_of(commit.author)}: #{commit.comment}")
    end
    
    def announce_new_commits
      @scm.commits_since(@since_revision.to_s).each do |commit|
        if @since_revision.before?(commit.revision)
          announce(commit)
          @since_revision = commit.revision
        end
      end
    end
  end
  
  def Blastr::temp_dir
    temp_file = Tempfile.new("tmp")
    temp_dir = temp_file.path
    temp_file.unlink
    temp_dir
  end

end

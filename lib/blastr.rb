$LOAD_PATH.unshift(File.dirname(__FILE__)) unless
  $LOAD_PATH.include?(File.dirname(__FILE__)) or $LOAD_PATH.include?(File.expand_path(File.dirname(__FILE__)))

module Blastr
  require File.expand_path(File.join(File.dirname(__FILE__), 'error.rb'))
  require File.expand_path(File.join(File.dirname(__FILE__), 'scm/scm.rb'))
  require File.expand_path(File.join(File.dirname(__FILE__), 'tts/tts.rb'))
  require File.expand_path(File.join(File.dirname(__FILE__), 'people/people.rb'))

  VERSION = '0.1.0'
  COPYRIGHT = "Copyright (c) 2009-#{Time.now.year}, Lasse Koskela. All Rights Reserved."
  
  def self.trap_and_exit(signal)
    trap(signal) {
      puts ""
      exit 0
    }
  end
  
  def self.delete_at_exit(file_or_directory)
    at_exit do
      puts "Cleaning up leftovers: #{temp_dir}" if File.directory?(temp_dir) if $DEBUG
      FileUtils.remove_dir(temp_dir, :force => true)
    end
  end

  class Process
    def initialize(args)
      Blastr::trap_and_exit("INT")
      validate(args)
      scm_url = args[0]
      @scm = Blastr::SourceControl.implementation_for(scm_url)
      @since_revision = @scm.as_revision(args[1]) if args.size > 1
      @since_revision = @scm.latest_revision unless args.size > 1
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
    
    private
    def announce_new_commits
      @scm.commits_since(@since_revision.to_s).each do |commit|
        if @since_revision.before?(commit.revision)
          announce(commit)
          @since_revision = commit.revision
        end
      end
    end
    def validate(args=[])
      raise UsageError.new if args.size == 0 or args.size > 2
    end
  end
  
  def Blastr::temp_dir
    temp_file = Tempfile.new("tmp")
    temp_dir = temp_file.path
    temp_file.unlink
    FileUtils.mkdir_p(temp_dir)
    temp_dir
  end
end

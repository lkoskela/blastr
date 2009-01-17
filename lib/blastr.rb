$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Blastr
  require 'scm/scm.rb'
  require 'tts/tts.rb'
  require 'people/people.rb'

  VERSION = '0.0.10'
  
  class UsageError < ArgumentError
    
    USAGE_TEXT = <<EOS

    Usage: blastr URL [revision]
    
    The options are as follows:
    
      URL        (required)  The URL identifying the source repository
                 you want to observe. For Subversion repositories the
                 URL could be, for example, "http://svn.foo.com/bar" or
                 "svn://svn.foo.com/bar". For a Git repository, the URL
                 usually looks like "git://github.com/foo/bar.git".
                 
      revision   (optional)  The revision or commit you want to start
                 observing from. For a Subversion repository, this 
                 would be a number (e.g. 123 or 5000). For Git, the
                 revision would be the commit SHA hash - something that
                 looks like "4d1863552c03bc1ff9c9376b9a24b04daabc67e2".
                 When this option is omitted, Blastr starts observing
                 from the latest revision onwards.

EOS
    
    def initialize
      super(USAGE_TEXT)
    end
  end

  class Process
    def initialize(args)
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
    temp_dir
  end

end

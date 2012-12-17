require File.expand_path(File.join(File.dirname(__FILE__), 'test_helper.rb'))
require 'mocha/setup'

module Blastr
  class Process
    attr_accessor :scm
    attr_reader :seconds_slept
    
    # override sleep() to speed up test runs
    def sleep(seconds)
      @seconds_slept ||= 0
      @seconds_slept += seconds
    end
    
    # override should_run? to make the process 
    # stop after three polling iterations
    def should_run?
      @iterations ||= 0
      @iterations += 1
      @iterations <= 3
    end
  end
end

class TestBlastrProcessArguments < Test::Unit::TestCase
  def test_command_line_arguments_are_validated
    assert_raise Blastr::UsageError do
      Blastr::Process.new([])
    end
    assert_raise Blastr::UsageError do
      Blastr::Process.new(["http://svn.com", "123", "too-much"])
    end
    assert_nothing_raised do
      Blastr::Process.new(["http://svn.com", "123"])
    end
  end
end

class TestBlastrProcess < Test::Unit::TestCase
  def setup
    @since_revision = '1'
    @process = create_blastr_process_polling("http://svn.com", @since_revision)
  end
  
  def test_polls_for_new_commits_every_30_seconds
    @process.expects(:announce_new_commits).times(3)
    @process.run
    assert_equal 3*30, @process.seconds_slept
  end
  
  def test_announcing_all_new_commits
    commits = [ fake_commit('2'), fake_commit('3') ]
    commit_sequence = sequence('commit sequence')
    @process.scm.expects(:commits_since).with(@since_revision).returns(commits)
    @process.expects(:announce).with(commits.first).in_sequence(commit_sequence)
    @process.expects(:announce).with(commits.last).in_sequence(commit_sequence)
    @process.send(:announce_new_commits)
  end
  
  def test_announcing_a_given_commit
    commit = fake_commit('42')
    Blastr::People.stubs(:full_name_of).returns('Full Name')
    Blastr::TTS.expects(:speak).with("Commit by Full Name: #{commit.comment}")
    @process.expects(:puts).with("[#{commit.revision}] Commit by #{commit.author}: #{commit.comment}")
    @process.announce(commit)
  end
  
  private
  
  def fake_commit(rev)
    revision = Blastr::SourceControl::SubversionRevision.new(rev)
    Blastr::SourceControl::LogEntry.new(revision, 'author', 'comment')
  end
  
  def create_blastr_process_polling(url, since_revision)
    process = Blastr::Process.new([url, since_revision])
    process.scm = mock()
    process.scm.class.any_instance.stubs(:name).returns('Fake')
    process
  end
end
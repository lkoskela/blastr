#!/usr/bin/env ruby

require 'rubygems'
require 'git'


#git_url = ARGV[0]
#since_date = ARGV[1] ||= "1000000000"
#
#temp_file = Tempfile.new("temp-git-clone")
#temp_dir = temp_file.path
#temp_file.unlink
#
#g = Git.clone(git_url, temp_dir)
#g.chdir do
#  puts "Using temporary clone at #{%x[pwd].strip}"
#  puts "Traversing logs since #{since_date}...\n"
#  begin
#    g.log.since(since_date).each do |commit|
#      puts "[#{commit.date.to_i}] Change by #{commit.author.name}: #{commit.message}"
#    end
#  ensure
#    FileUtils.remove_dir(temp_dir, :force => true)
#  end
#end

def temp_dir
  temp_file = Tempfile.new("tmp")
  temp_dir = temp_file.path
  temp_file.unlink
  temp_dir
end

module Blastr
  class Git
    def self.init(git_url, clone_dir, since_revision)
      Blastr::Git.new(git_url, clone_dir, since_revision)
    end
    def initialize(git_url, clone_dir, since_revision)
      @git_url = git_url
      @last_revision = since_revision
      puts "Cloning #{git_url} ..."
      @clone = ::Git.clone(git_url, temp_dir)
    end
    def commits_since(revision)
      @clone.pull
      @clone.chdir do
        puts "scanning log for commits since #{revision}..."
        commits = []
        @clone.log.since(revision).each do |commit|
          commits << commit
        end
        commits
      end
    end
  end
end

git_url = ARGV[0]
since_revision = ARGV[1] ||= "1000000000"

begin
  scm = Blastr::Git.init(git_url, temp_dir, since_revision)
  last_revision = since_revision.to_i
  while true
    scm.commits_since(last_revision.to_s).reverse.each do |commit|
      puts "processing commit made on #{commit.date}"
      candidate_revision = commit.date.to_i
      puts "skip revision #{candidate_revision}" unless last_revision < candidate_revision
      puts "[#{commit.date.to_i}] Commit by #{commit.author.name}: #{commit.message}" if last_revision < candidate_revision
      last_revision = candidate_revision
    end
    sleep 30
  end
ensure
  FileUtils.remove_dir(temp_dir, :force => true)
end
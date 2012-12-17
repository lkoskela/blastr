# encoding: UTF-8
require 'fileutils'

module Blastr::FileSystem
  def self.delete_at_exit(file_or_directory)
    at_exit do
      if (File.exist?(file_or_directory))
        puts "Cleaning up leftovers: #{file_or_directory}" if $DEBUG
        FileUtils.rm_r(file_or_directory, :force => true, :secure => true)
      end
    end
  end
  
  def self.temp_dir
    temp_file = Tempfile.new("tmp")
    temp_dir = temp_file.path
    temp_file.unlink
    FileUtils.mkdir_p(temp_dir)
    temp_dir
  end
end
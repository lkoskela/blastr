require File.expand_path(File.join(File.dirname(__FILE__), 'test_helper.rb'))

module Blastr::FileSystem
  # intercept calls to Kernel.at_exit to allow invoking
  # registered at_exit blocks before the process exits
  def self.at_exit(&block)
    @at_exit_blocks ||= []
    @at_exit_blocks << block
  end
  
  def self.execute_all_at_exit_blocks
    @at_exit_blocks.each { |block| block.call }
  end
end

class FileSystemTest < Test::Unit::TestCase
  
  def setup
    @file_to_delete = File.expand_path(File.join(Blastr::FileSystem.temp_dir, 'file_to_be_deleted'))
    FileUtils.touch(@file_to_delete)
  end
  
  def teardown
    FileUtils.rm(@file_to_delete) if File.exist?(@file_to_delete)
  end
  
  def test_delete_at_exit
    Blastr::FileSystem.delete_at_exit(@file_to_delete)
    assert File.exist?(@file_to_delete)
    Blastr::FileSystem.execute_all_at_exit_blocks
    assert ! File.exist?(@file_to_delete)
  end

end
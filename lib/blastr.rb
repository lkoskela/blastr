$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Blastr
  VERSION = '0.0.3'

  require 'blastr/git.rb'
  require 'blastr/svn.rb'
  
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

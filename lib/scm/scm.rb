# encoding: UTF-8

module Blastr::SourceControl
  
  @@implementations = []
  
  def self.implementation_for(url)
    matching_implementations = @@implementations.find_all { |impl| impl.understands_url?(url) }
    raise "No SCM implementation found that would understand #{url}" if matching_implementations.empty?
    raise "Ambiguous SCM URL #{url} - please prefix it with the type of repository ('svn:', 'git:', 'hg:')" if matching_implementations.size > 1
    return matching_implementations.first.new(url)
  end
  
  def self.register_implementation(implementation)
    @@implementations << implementation unless @@implementations.include?(implementation)
  end
  
end

['svn', 'git', 'hg'].each do |scm|
  require File.expand_path(File.join(File.dirname(__FILE__), "#{scm}/#{scm}.rb"))
end

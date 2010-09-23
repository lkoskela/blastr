require File.dirname(__FILE__) + '/test_helper.rb'

class AbstractScmTestCase < Test::Unit::TestCase
  
  abstract

  def assert_urls_are_understood(list_of_urls)
    list_of_urls.each do |url|
      assert scm.understands_url?(url), "#{url} should be understood by #{scm}!"
    end
  end

  def scm
    raise "#{self.class} needs to implement the method scm()"
  end
end
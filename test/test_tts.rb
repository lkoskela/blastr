require File.dirname(__FILE__) + '/test_helper.rb'

class TestTTSImplementation < Test::Unit::TestCase

  def test_availability_depends_on_binary_existing_in_PATH
    assert Blastr::TTS::TTSImplementation.new("nosuchbinaryexists").available? == false
    assert Blastr::TTS::TTSImplementation.new("echo").available? == true
  end
end

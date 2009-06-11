require File.dirname(__FILE__) + '/test_helper.rb'
require 'mocha'

class TestTTSImplementation < Test::Unit::TestCase
  def test_availability_depends_on_binary_existing_in_PATH
    assert Blastr::TTS::TTSImplementation.new("nosuchbinaryexists").available? == false
    assert Blastr::TTS::TTSImplementation.new("echo").available? == true
  end
end

class TestCamelCaseSpelling < Test::Unit::TestCase
  def setup
    @tts = mock()
    Blastr::TTS.stubs(:resolve_tts_system).returns(@tts)
  end

  def test_spelling_out_camel_case_words
    @tts.expects(:speak).with("this is Camel Case")
    Blastr::TTS.speak("this is CamelCase")
  end

  def test_camel_case_words_ending_with_special_character
    @tts.expects(:speak).with("is this Camel Case ?")
    Blastr::TTS.speak("is this CamelCase?")
  end
end

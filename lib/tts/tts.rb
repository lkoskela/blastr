# encoding: UTF-8
module Blastr
  module TTS
    
    class TTSImplementation
      attr_accessor :name
      
      def initialize(name)
        @name = name
      end
      
      def binary
        %x[#{locate_which_binary} #{@name}].strip
      end
      
      def available?
        binary.empty? == false
      end
      
      def speak(msg)
        %x[#{binary} "#{msg}"]
      end

      private
      def locate_which_binary
        @path_to_which_command ||= ['/bin/which', '/usr/bin/which'].find do |path|
          File.exists? path
        end
        @path_to_which_command ||= 'which'
      end
    end

    class Say < TTSImplementation
      def initialize; super("say"); end
    end

    class Espeak < TTSImplementation
      def initialize; super("espeak"); end
    end

    class Festival < TTSImplementation
      def initialize; super("festival"); end
      def speak(msg)
        %x[echo "#{msg}" | #{binary} --tts]
      end
    end

    def TTS::resolve_tts_system
      return $tts unless $tts.nil?
      [ Say.new, Espeak.new, Festival.new ].each do |impl|
        return impl if impl.available?
      end
      raise "No TTS implementation found."
    end

    def TTS::speak(msg)
      msg.gsub!(/"/u, '\"')
      msg.gsub!(/'/u, '\'')
      resolve_tts_system.speak(normalize_for_speech(msg))
    end

    private
    def TTS::normalize_for_speech(msg)
      msg = omit_url_scheme("git", msg)
      msg = omit_url_scheme("http", msg)
      msg = omit_url_scheme("https", msg)
      msg.gsub!(/(.*?)([^\w\(\)])(.?)/, '\1 \2 \3').squeeze!(" ")
      words = msg.split(/\s/).collect do |word|
        camel_case_word = /[A-Z][a-z0-9_]+/
        if word =~ camel_case_word
          word = word.scan(camel_case_word)
        end
        word
      end
      words.flatten.join(' ')
    end
    
    def TTS::omit_url_scheme(scheme, msg)
      return nil if msg.nil?
      msg.gsub!(/\b#{scheme}:\/\/([^\s]+)/, '(path omitted)')
      msg
    end
  end
end
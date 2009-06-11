module Blastr
  module TTS
    
    class TTSImplementation
      attr_accessor :name
      
      def initialize(name)
        @name = name
      end
      
      def binary
        %x[which #{@name}].strip
      end
      
      def available?
        binary.empty? == false
      end
      
      def speak(msg)
        %x[#{binary} "#{msg}"]
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
      msg.gsub!(/(.*?)([^\w])(.?)/, '\1 \2 \3').squeeze!
      words = msg.split(/\s/).collect do |word|
        camel_case_word = /[A-Z][a-z0-9_]+/
        if word =~ camel_case_word
          word = word.scan(camel_case_word)
        end
        word
      end
      words.flatten.join(' ')
    end
  end
end
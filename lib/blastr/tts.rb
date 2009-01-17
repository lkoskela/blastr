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
      resolve_tts_system.speak(msg)
    end

  end
end
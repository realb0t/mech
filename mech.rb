module Mech

  VERSION = [ 0, 0, 1 ]

  autoload :Config, File.join(File.dirname(__FILE__), 'mech/config')
  autoload :Compiler, File.join(File.dirname(__FILE__), 'mech/compiler')
  
  class Compiler
    autoload :Format, File.join(File.dirname(__FILE__), 'mech/compiler/format')
    
    class Format
      autoload :Format, File.join(File.dirname(__FILE__), 'mech/compiler/format/ruby')
      autoload :Format, File.join(File.dirname(__FILE__), 'mech/compiler/format/actionscript')
      autoload :Format, File.join(File.dirname(__FILE__), 'mech/compiler/format/javascript')
    end
  end

  class << self

    def init(path = nil)
      require path || File.join(File.dirname(__FILE__), 'mech_conf')
      @config ||= Mech::Config.instance
    end

    def config
      unless @config
        if init
          @config ||= Mech::Config.instance
        else
          raise 'Not load config file'
        end
      end

      @config
    end

    def construct_data

    end

    def compile!

    end

  end
end

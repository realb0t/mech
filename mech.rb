module Mech

  VERSION = [ 0, 0, 1 ]

  autoload :Config, File.join(File.dirname(__FILE__), 'mech/config')

  class << self

    def init(path = nil)
      require path || File.join(File.dirname(__FILE__), 'mech_conf')
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

    def compile!

    end

  end
end

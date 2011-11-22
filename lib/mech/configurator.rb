module Mech::Configurator

  def init(path = nil)
    require path || File.join(File.dirname(__FILE__), '..', 'mech_conf')
    @config ||= Mech::Config.instance
    self
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

end

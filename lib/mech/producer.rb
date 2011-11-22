class Mech::Producer

  include Mech::Configurator

  def initialize(paths)
    @paths = paths
  end

end

require 'erb'

class Mech::Compiler::Format

  include Mech::Configurator

  def compile(data, params = {}, &block)
    raise 'Compile method not exist'
  end

  def initialize(*args)
    @data = {}
  end

  def with_template
    ERB.new(File.read(tmp_path)).result(binding)
  end

  def tmp_path
    raise 'Not defined tmp path'
  end

  def output
    @data
  end

end

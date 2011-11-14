require 'json'

class Mech::Compiler::Format::JavaScript < Mech::Compiler::Format

  def tmp_path
    @tmp_path ||= File.join(config.tmp_path, 'java_script.erb')
  end

  def compile(data, params = {})
    @data = data
    self.with_template
  end


end

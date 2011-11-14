require 'psych'

class Mech::Compiler::Format::Yaml < Mech::Compiler::Format

  def tmp_path
    @tmp_path ||= File.join(config.tmp_path, 'yaml.erb')
  end

  def compile(data, params = {})
    @data = data
    with_template
  end


end

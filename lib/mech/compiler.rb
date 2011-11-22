class Mech::Compiler

  def self.build(format, params = {})
    Mech::Compiler::Format.const_get(format).new
  end

end

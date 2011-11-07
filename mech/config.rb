require 'singleton'

class Mech::Config
  include Singleton

  def self.init(&block)
    instance.init(&block)
  end
  
  def method_missing(variable, *args, &block)
    if block_given?
      args.unshift(self)
      instance_variable_set("@#{variable}", lambda { block.call(*args) })
    elsif args.size > 0
      instance_variable_set("@#{variable}", args.shift)
    else
      value = instance_variable_get("@#{variable}")
      value.respond_to?(:call) ? value.call : value
    end
  end

  def init(&block)
    instance_eval(&block)
  end
end

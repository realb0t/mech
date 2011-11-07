require 'singleton'

class Mech::Config
  include Singleton
  attr_accessor :bin_path, :src_path

  def self.init(&block)
    instance(&block)
  end

  def bin_path(value = nil)
    @bin_path ||= value
  end

  def src_path(value = nil)
    @src_path ||= value
  end

  def init(&block)
    instance_eval(&block)
  end
end

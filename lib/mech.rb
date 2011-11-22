require 'find'
require 'yaml'
require 'psych'

unless {}.respond_to?(:deep_merge)
  class Hash
    def deep_merge(*args)
      merge(*args)
    end

    def deep_merge!(*args)
      merge!(*args)
    end
  end
end

module Mech

  VERSION = [ 0, 0, 1 ]

  def self.auto_path(path)
    File.join(File.dirname(__FILE__), path)
  end

  autoload :Configurator, File.join(File.dirname(__FILE__), 'mech/configurator')
  autoload :Config,       File.join(File.dirname(__FILE__), 'mech/config')
  autoload :Compiler,     File.join(File.dirname(__FILE__), 'mech/compiler')
  autoload :Producer,     File.join(File.dirname(__FILE__), 'mech/producer')
  autoload :PathLoader,   File.join(File.dirname(__FILE__), 'mech/path_loader')

  class Producer
    autoload :Common , File.join(File.dirname(__FILE__), 'mech/producer/common')
    autoload :Default, File.join(File.dirname(__FILE__), 'mech/producer/default')
  end

  class Compiler
    autoload :Format, File.join(File.dirname(__FILE__), 'mech/compiler/format')

    class Format
      autoload :Yaml, File.join(File.dirname(__FILE__),
        'mech/compiler/format/yaml')

      autoload :JavaScript, File.join(File.dirname(__FILE__),
        'mech/compiler/format/java_script')
    end
  end

  class << self

    include Mech::Configurator

    def compile(params = {})
      producer_name = params[:producer_name] || config.producer
      compile_format = params[:compiler_format] || config.compiler
      config_path = params[:config_path]

      init(config_path) if config_path

      loader   = Mech::PathLoader.new(config)
      producer = Mech::Producer.const_get(producer_name).new(loader.paths)
      compiler = Mech::Compiler.build(compile_format)

      data     = producer.produce

      compiler.compile(data)
    end

  end
end

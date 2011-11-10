require 'find'
require 'yaml'
require 'psych'

unless {}.respond_to?(:deep_merge)
  class Hash
    def deep_merge(*args)
      merge(*args)
    end
  end
end

module Mech

  VERSION = [ 0, 0, 1 ]

  autoload :Configurator, File.join(File.dirname(__FILE__), 'mech/configurator')
  autoload :Config, File.join(File.dirname(__FILE__), 'mech/config')
  autoload :Compiler, File.join(File.dirname(__FILE__), 'mech/compiler')
  autoload :Producer, File.join(File.dirname(__FILE__), 'mech/producer')
  autoload :PathLoader, File.join(File.dirname(__FILE__), 'mech/path_loader')

  class Producer
    autoload :Common , File.join(File.dirname(__FILE__), 'mech/producer/common')
  end

  class Compiler
    autoload :Format, File.join(File.dirname(__FILE__), 'mech/compiler/format')

    class Format
      autoload :Format, File.join(File.dirname(__FILE__),
        'mech/compiler/format/ruby')

      autoload :Format, File.join(File.dirname(__FILE__),
        'mech/compiler/format/actionscript')

      autoload :Format, File.join(File.dirname(__FILE__),
        'mech/compiler/format/javascript')
    end
  end

  class << self

    include Mech::Configurator

    def produce
      loader = Mech::PathLoader.new(config)
      prod = Mech::Producer::Common.new(loader.paths)
      prod.produce
    end

    def compile!

    end

  end
end

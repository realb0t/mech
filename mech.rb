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

  class Producer
    autoload :Common , File.join(File.dirname(__FILE__), 'mech/producer/common')
  end

  class Compiler
    autoload :Format, File.join(File.dirname(__FILE__), 'mech/compiler/format')

    class Format
      autoload :Format, File.join(File.dirname(__FILE__), 'mech/compiler/format/ruby')
      autoload :Format, File.join(File.dirname(__FILE__), 'mech/compiler/format/actionscript')
      autoload :Format, File.join(File.dirname(__FILE__), 'mech/compiler/format/javascript')
    end
  end

  class << self

    include Mech::Configurator

    def init_paths
      @paths = []
      Find.find(config.src_path) { |f|
        @paths.push(f) if f.match(/\.yml\Z/)
      }
    end

    def filter_paths_by_env
      @paths.select! do |path|
        path =~ Regexp.new(File.join(config.src_path, config.env))
      end
    end

    def produce
      init_paths
      filter_paths_by_env
      prod = Mech::Producer::Common.new(@paths)
      prod.produce
    end

    def compile!

    end

  end
end

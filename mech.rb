require 'find'
require 'yaml'

module Mech

  VERSION = [ 0, 0, 1 ]

  autoload :Config, File.join(File.dirname(__FILE__), 'mech/config')
  autoload :Compiler, File.join(File.dirname(__FILE__), 'mech/compiler')

  class Compiler
    autoload :Format, File.join(File.dirname(__FILE__), 'mech/compiler/format')

    class Format
      autoload :Format, File.join(File.dirname(__FILE__), 'mech/compiler/format/ruby')
      autoload :Format, File.join(File.dirname(__FILE__), 'mech/compiler/format/actionscript')
      autoload :Format, File.join(File.dirname(__FILE__), 'mech/compiler/format/javascript')
    end
  end

  class << self

    def init(path = nil)
      require path || File.join(File.dirname(__FILE__), 'mech_conf')
      @config ||= Mech::Config.instance
    end

    def config
      unless @config
        if init
          @config ||= Mech::Config.instance
        else
          raise 'Not load config file'
        end
      end

      @config
    end

    def init_paths
      @paths = []
      Find.find(config.src_path) { |f|
        @paths.push(f) if f.match(/\.yml\Z/)
      }
    end

    def build_merge_graph
      @paths_with_deep = @paths.map do |path|
        otn_path = path.gsub(config.src_path, '')
        path_deep = otn_path.split('/').size
        [otn_path, path_deep]
      end
      @paths_with_deep.sort_by! { |p| p[1] }
    end

    def type_merge(path)
      path
    end

    def merge_recursive
      @paths_with_deep.delete_if { |p| p[0] == '/common.yml' }
      @common_obj = YAML.load(File.read(config.src_path + '/common.yml'))

      type_index = @paths_with_deep[0][1]
      @types = @paths_with_deep.select { |y| y[1] == type_index }.map(&:first)
      @paths_with_deep.delete_if { |y| y[1] == type_index }
      @paths = @paths_with_deep.map(&:first)

      @types.map { |type_path| type_merge(type_path) }
    end

    def construct_data
      init_paths
      build_merge_graph
      merge_recursive
    end

    def compile!

    end

  end
end

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
        path_deep = path.split('/').size
        [path, path_deep]
      end
      @paths_with_deep.sort_by! { |p| p[1] }
      @min_path_deep = @paths_with_deep.first[1]
      @max_path_deep = @paths_with_deep.last[1]
    end

    def build_extend_object(path, pattern)
      paths = path.split('/')
      paths.pop
      path = paths.join('/') + '.yml'

      if File.exist?(path)
        obj = Psych.load(File.read(path))
        pattern = pattern.deep_merge(obj || {})
      end

      if path =~ Regexp.new(config.src_path)
        pattern = build_extend_object(path, pattern)
      end

      pattern
    end

    def merge_recursive
      @paths_with_deep.delete_if { |p| p[0] == '/common.yml' }
      @common_obj = YAML.load(File.read(config.src_path + '/common.yml'))

      @stored_paths = @paths_with_deep.select { |p, d| d == @max_path_deep }.map(&:first)

      merged_items_by_path = @stored_paths.map do |stored_path|
        extend_obj = build_extend_object(stored_path, {})
        objs = Psych.load(File.read(stored_path))

        objs.each do |name, obj|
          objs[name] = @common_obj.deep_merge(extend_obj.deep_merge(obj))
        end

        objs
      end
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

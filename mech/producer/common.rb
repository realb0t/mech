class Mech::Producer::Common < Mech::Producer

    def produce
      build_merge_graph
      merge_recursive
    end

    protected

      def build_merge_graph
        @paths_with_deep = @paths.map do |path|
          path_deep = path.split('/').size
          [path, path_deep]
        end
        @paths_with_deep.sort_by! { |p| p[1] }
        @min_path_deep = @paths_with_deep.first[1]
        @max_path_deep = @paths_with_deep.last[1]
      end

      def merge_recursive
        @paths_with_deep.delete_if { |p| p[0] == '/common.yml' }
        @common_obj = YAML.load(File.read(config.src_path + '/common.yml'))

        @stored_paths = @paths_with_deep.select { |p, d|
          d == @max_path_deep }.map(&:first)

        merged_items_by_path = @stored_paths.map do |stored_path|
          extend_obj = build_extend_object(stored_path, {})
          objs = Psych.load(File.read(stored_path))

          objs.each do |name, obj|
            objs[name] = @common_obj.deep_merge(extend_obj.deep_merge(obj))
          end

          objs
        end
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

end

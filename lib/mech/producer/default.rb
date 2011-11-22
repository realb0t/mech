class Mech::Producer::Default < Mech::Producer

  def produce
    @common_obj = Psych.load(File.read(config.src_path + '/common.yml'))

    @meta_type_title = load_meta_type_titles - [ 'common' ]
    @primary_meta_type_objs  = load_meta_type_objs(config.src_path)

    src_path = config.src_path
    env = config.env
    env_src_path = File.join(src_path, env)

    @secodry_meta_type_objs  = load_meta_type_objs(env_src_path)

    contents = {}
    @meta_type_title.each do |type|
      contents[type] = load_dir_contents(File.join(env_src_path, type))
      contents[type].each do |name, val|
        meta_type_obj = @common_obj.deep_merge(@primary_meta_type_objs[type])
        meta_type_obj = meta_type_obj.deep_merge(@secodry_meta_type_objs[type])
        contents[type][name] = meta_type_obj.deep_merge(val)
      end
    end

    contents
  end

  def load_meta_type_titles
    paths = Dir.new(config.src_path).find.to_a.select do |path|
      path =~ /.*\.yml/
    end
    paths.map { |path| path.gsub(/\.yml/, '') }
  end

  def load_meta_type_objs(src_path)
    paths = Dir.new(src_path).find.to_a.select do |path|
      path =~ /.*\.yml/
    end

    keys = paths.map { |path| path.gsub(/\.yml/, '') }

    values = paths.map do |path|
      content = File.read(File.join(src_path, path))
      Psych.load(content)
    end

    obj = {}

    keys.each_with_index do |key, index|
      obj[key] = values[index]
    end

    obj
  end

  def load_dir_contents(path)
    dir = Dir.new(path)

    dirs = dir.find.to_a.select { |name|
      File.directory?(File.join(path, name)) && ! ['.', '..', '...'].include?(name)
    }.map { |name| [name, File.join(path, name)] }

    contents = dir.find.to_a.select { |name|
      name =~ /\.yml/
    }.map { |name|
      [ name.gsub(/\.yml/, ''), Psych.load(File.read(File.join(path, name))) ]
    }
    contents = Hash[contents]

    nested_contents = {}
    dirs.each { |name, dir|
      nested_contents[name] = load_dir_contents(dir)
    }

    if dirs.size.zero?
      return contents.values.first
    else
      objs = {}

      nested_contents.each do |type, scope|
        scope.each do |name, v|
          objs[name] = contents[type].deep_merge(v) if nested_contents[type][name]
        end
      end

      return objs
    end

  end
end

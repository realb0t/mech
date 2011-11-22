class Mech::PathLoader
  attr_accessor :paths

  def initialize(config)
    @paths = []
    @config = config
    find_paths
    filter_paths_by_env
  end

  protected

    def find_paths
      Find.find(@config.src_path) { |f|
        @paths.push(f) if f.match(/\.yml\Z/)
      }
    end

    def filter_paths_by_env
      @paths.select! do |path|
        path =~ Regexp.new(File.join(@config.src_path, @config.env))
      end
    end


end

Mech::Config.init do
  bin_path File.join(File.dirname(__FILE__), 'bin')
  src_path File.join(File.dirname(__FILE__), 'mech_src')
  tmp_path File.join(File.dirname(__FILE__), 'mech', 'compiler', 'tmp')
  enviropment 'env1'
  producer 'Common'
  compiler 'Yaml'
end

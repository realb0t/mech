Mech::Config.init do
  bin_path './'
  src_path File.join(File.dirname(__FILE__), 'src')
  tmp_path File.join(File.dirname(__FILE__), 'mech', 'compiler', 'tmp')
  enviropment 'env'
  producer 'Common'
  compiler 'Yaml'
end

Mech::Config.init do
  bin_path File.join(File.dirname(__FILE__), 'bin')
  src_path File.join(File.dirname(__FILE__), 'mech_src')
  enviropment 'env1'
end

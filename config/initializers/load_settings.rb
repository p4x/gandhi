settings_path = Rails.root.join('config', 'settings.yml')
if !File.exist?(settings_path)
  puts "Settings file does not exist: #{settings_path}"
  puts "Run 'rake gandhi:copy_settings' to copy the example settings file to this path"
  GANDHI_SETTINGS = {}
else
  GANDHI_SETTINGS = YAML.load_file(settings_path)[Rails.env]
end
salt_path = Rails.root.join('config', 'salt.yml')
if File.exist?(salt_path)
  salt_yaml = YAML.load_file(salt_path)
  SALT ||= salt_yaml['salt']
  CLIENT_SALT ||= salt_yaml['client_salt']
else
  SALT = nil
  CLIENT_SALT = nil
  puts "Warning: the Gandhi salt file has not been generated yet (RAILS_ROOT/config/salt.yml)"
  puts "Run 'rake gandhi:salt' to generate this file"
end
settings_path = Rails.root.join('config', 'settings.yml')
if !File.exist?(settings_path)
  puts "Settings file does not exist (RAILS_ROOT/config/settings.yml)"
  puts "Copy RAILS_ROOT/config/settings.example.yml to RAILS_ROOT/config/settings.yml to get started"
  raise "Missing RAILS_ROOT/config/settings.yml file"
end
GANDHI_SETTINGS = YAML.load_file(settings_path)[Rails.env]
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
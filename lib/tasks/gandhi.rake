namespace :gandhi do
  desc "Generate application-wide salts and save them to RAILS_ROOT/config/salt.yml"
  task :salt => :environment do
    salt_file_path = Rails.root.join('config', 'salt.yml')
    salt_base64_encoded = SecureRandom.base64(48)
    client_salt_base64_encoded = SecureRandom.base64(48)
    salt_hash = {'salt' => salt_base64_encoded, 'client_salt' => client_salt_base64_encoded}
    File.open(salt_file_path, "w+") do |f|
      f.write(salt_hash.to_yaml)
    end
    if File.exist?(salt_file_path)
      puts "Application salts generated and saved to: #{salt_file_path}"
    end
  end

  desc "Copy the example settings file to RAILS_ROOT/config/settings.yml"
  task :copy_settings => :environment do
    settings_example_path = Rails.root.join('config', 'settings.example.yml')
    settings_path = Rails.root.join('config', 'settings.yml')
    if File.exist?(settings_path)
      puts "Settings file already exists at RAILS_ROOT/config/settings.yml"
      return true
    end
    FileUtils.copy(settings_example_path, settings_path)
    if File.exist?(settings_path)
      puts "Example settings file copied to: #{settings_path}"
    end
  end

  desc "Setup the Gandhi application (copy settings, generate salts)"
  task :setup => [:copy_settings, :salt]

end

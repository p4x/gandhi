namespace :gandhi do
  desc "Generate an application salt and save it to RAILS_ROOT/config/salt.yml"
  task :salt => :environment do
    salt_file_path = Rails.root.join('config', 'salt.yml')
    salt_base64_encoded = SecureRandom.base64(48)
    client_salt_base64_encoded = SecureRandom.base64(48)
    salt_hash = {'salt' => salt_base64_encoded, 'client_salt' => client_salt_base64_encoded}
    File.open(salt_file_path, "w+") do |f|
      f.write(salt_hash.to_yaml)
    end
  end
end
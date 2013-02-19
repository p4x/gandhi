class GandhiTools

  # Encrypts a message using AES-256
  def self.encrypt(message, passphrase)
    aes = OpenSSL::Cipher.new('AES-256-CFB')
    aes.encrypt
    key, iv = GandhiTools.get_key_iv(passphrase, aes.key_len, aes.iv_len)
    aes.key = key
    aes.iv = iv
    encrypted_data = aes.update(message) + aes.final
    return encrypted_data
  end

  # Decrypts a message using AES-256
  def self.decrypt(encrypted_data, passphrase)
    aes = OpenSSL::Cipher.new('AES-256-CFB')
    aes.decrypt
    key, iv = GandhiTools.get_key_iv(passphrase, aes.key_len, aes.iv_len)
    aes.key = key
    aes.iv = iv
    decrypted_data = aes.update(encrypted_data) + aes.final
    return decrypted_data
  end

  # Returns a key and iv based upon the specified passphrase, using
  #   the number of iterations specified in the settings.yml file
  def self.get_key_iv(passphrase, key_len, iv_len)
    salt_decoded = Base64.decode64(SALT)
    iterations = GANDHI_SETTINGS['iterations']
    data = PBKDF2.new do |p|
      p.hash_function = 'sha256'
      p.password = passphrase
      p.salt = salt_decoded
      p.iterations = iterations
      p.key_length = key_len + iv_len
    end.bin_string
    [ data[0, key_len], data[key_len, iv_len] ]
  end

  def self.hash_remote_ip(ip_address)
    salt_decoded = Base64.decode64(SALT)
    iterations = GANDHI_SETTINGS['remote_host_iterations']
    data = PBKDF2.new do |p|
      p.hash_function = 'sha256'
      p.password = ip_address
      p.salt = salt_decoded
      p.iterations = iterations
      p.key_length = 64
    end.hex_string
  end

end

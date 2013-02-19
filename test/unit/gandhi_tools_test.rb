require 'test_helper'

class GandhiToolsTest < ActiveSupport::TestCase

  test "encrypting and decrypting a simple message" do
    message = 'Meet at Tahrir square at 3pm'
    passphrase = '9E39HsZBPLPWE/hbh8Zx6fABa/lRWrcyWP5H6cjFeEs='
    encrypted_data = GandhiTools.encrypt(message, passphrase)
    decrypted_data = GandhiTools.decrypt(encrypted_data, passphrase)
    assert_equal message, decrypted_data
  end

  test "hashing the same IP address results in the same hash value" do
    ip = '173.194.33.39'
    hash1 = GandhiTools.hash_remote_ip(ip)
    hash2 = GandhiTools.hash_remote_ip(ip)
    assert_equal hash1, hash2
  end

end

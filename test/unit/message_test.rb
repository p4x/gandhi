require 'test_helper'

class MessageTest < ActiveSupport::TestCase

  def setup
    #@passphrase = 'passphrase99'
    @encrypted_passphrase = '9E39HsZBPLPWE/hbh8Zx6fABa/lRWrcyWP5H6cjFeEs='
    #@hello = Message.construct!('This is my message', @encrypted_passphrase)
  end

  test "create a new message and decrypt its data using a provided passphrase" do
    raw_message_text = 'Be the change you wish to see in the world'
    message = Message.construct!(raw_message_text, @encrypted_passphrase)
    decrypted_data = message.decrypt(@encrypted_passphrase)
    assert_equal raw_message_text, decrypted_data
  end
end

class Message < ActiveRecord::Base
  validates :encrypted_message, :presence => true
  validates :encrypted_passphrase, :uniqueness => true
  validates :destroy_after, :numericality => { :only_integer => true, :greater_than => -1}
  scope :by_encrypted_passphrase, lambda { |enc_pcode| where(encrypted_passphrase: enc_pcode) }

  def decrypt(passphrase)
    GandhiTools.decrypt(self.decode64_encrypted_message, passphrase)
  end

  def decode64_encrypted_message
    Base64.strict_decode64(self.encrypted_message)
  end

  # Usage:
  #   Message.construct!('This is my message', 'password123', 6.hours)
  def self.construct!(body, passphrase, expires_in = 6.hours, destroy_after = 30.seconds)
    encrypted_data = GandhiTools.encrypt(body, passphrase)
    encrypted_data_base64_encoded = Base64.strict_encode64(encrypted_data)
    expires_at = expires_in.from_now
    destroy_after_seconds = destroy_after.to_i

    message = Message.new
    message.encrypted_message = encrypted_data_base64_encoded
    message.encrypted_passphrase = passphrase
    message.expires_at = expires_at
    message.destroy_after = destroy_after_seconds
    message.save
    return message
  end

  # Finds both:
  # * messages whose expires_at field is after the present time
  # * messages that should self-destruct (they've been viewed, and Time.now is greater than
  #      their viewed_at time plus the # of seconds after which they should expire)
  def self.sweep_expired_messages!
    to_expire = Message.all(:conditions => ["expires_at < ?", Time.now]) #("expires_at < ?", Time.now)
    to_expire.map { |m| m.destroy }
    # TODO: make this query more efficient (via SQL)
    Message.all(:conditions => ["viewed_at is not null"]).each do |message|
      destroy_after_datetime = message.viewed_at + message.destroy_after
      if destroy_after_datetime < Time.now
        message.destroy
      end
    end
  end

end
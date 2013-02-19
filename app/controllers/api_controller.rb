class ApiController < ApplicationController
  before_filter :banned_host_check

  respond_to :json

  def create_message
    message = params[:message]
    body = message[:body]
    encrypted_passphrase = message[:encrypted_passphrase]
    expires_after_seconds = (message[:expires_at] || 10.minutes.to_i).to_i
    if expires_after_seconds < 0
      expires_after_seconds = 0
    end
    if expires_after_seconds > 24.hours.to_i
      expires_after_seconds = 24.hour.to_i
    end
    destroy_after = (message[:destroy_after] || 99999).to_i
    if destroy_after < 0
      destroy_after = 0
    end
    @message = Message.construct!(body, encrypted_passphrase, expires_after_seconds, destroy_after)
    if @message && !@message.new_record?
      response_json = {'created' => 'true'}
      render json: response_json
    else
      errors_json = {'created' => 'false', 'error' => 'there was a problem creating your message'}
      render json: errors_json, status: :unprocessable_entity
    end
  end

  def view_message
    encrypted_passphrase = params[:encrypted_passphrase]
    # First sweep expired messages so they will not appear in our search results
    Message.sweep_expired_messages!
    # Find the message based on its PBKDF2-generated passphrase
    @message = Message.by_encrypted_passphrase(encrypted_passphrase).first
    if !@message.nil?
      decrypted_data = @message.decrypt(encrypted_passphrase)
      response_json = {'message' => decrypted_data, 'encrypted_passphrase' => encrypted_passphrase}
      @message.viewed_at = Time.now
      @message.save!
      render json: response_json
      if (@message.destroy_after == 0)
        # Self-destruct message now if set to do so immediately
        @message.destroy
      else
        # Set the viewed_at property, but only if it has not been set yet
        @message.update_attribute(:viewed_at, Time.now) if @message.viewed_at.nil?
      end
    else
      # Ues Rails' best determination of what the remote IP address is
      remote_ip = request.remote_ip
      # Log the failed attempt
      FailedAttemptLog.construct!(remote_ip)
      errors_json = {'error' => 'message not found'}
      render json: errors_json, status: :unprocessable_entity
    end
  end

  private

  def banned_host_check
    # Ues Rails' best determination of what the remote IP address is
    remote_ip = request.remote_ip
    banned_host = BannedHost.find_by_ip(remote_ip)
    if !banned_host.nil?
      # Host has been banned. Redirect to /500.html before they can make another attempt
      redirect_to '/500.html'
      return false
    else
      return true
    end
  end

end

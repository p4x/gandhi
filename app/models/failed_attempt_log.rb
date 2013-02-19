class FailedAttemptLog < ActiveRecord::Base
  # Usage:
  #   FailedAttemptLog.construct!('131.253.13.32')
  # If a failed attempt already exists for this remote host, it will return:
  #  [true, @failed_attempt_log]
  # If a failed attempt for this host is not in the database, it returns:
  #  [false, @failed_attempt_log]
  def self.construct!(remote_host)
    remote_ip_hash = GandhiTools.hash_remote_ip(remote_host)
    log = FailedAttemptLog.where("remote_host_hash = ?", remote_ip_hash).first
    if !log.nil?
      log.attempt_count += 1
      log.save!
      if log.attempt_count >= GANDHI_SETTINGS['ban_after_fail_attempts']
        # If this is the tenth failed attempt from this host, add the IP address to the banned_hosts table
        banned = BannedHost.new
        banned.remote_host_hash = log.remote_host_hash
        banned.save!
      end
      return true, log
    else
      log = FailedAttemptLog.new
      log.remote_host_hash = remote_ip_hash
      log.save!
      return false, log
    end
  end

end

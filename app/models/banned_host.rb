class BannedHost < ActiveRecord::Base
  
  # Hashes the given IP and performs a lookup based on the hash
  def self.find_by_ip(ip)
    remote_ip_hash = GandhiTools.hash_remote_ip(ip)
    banned_host = BannedHost.where("remote_host_hash = ?", remote_ip_hash).first
    return banned_host
  end

end

require 'test_helper'

class BannedHostTest < ActiveSupport::TestCase

  test "find by IP" do
    ip = '1.1.1.1'
    was_found = BannedHost.find_by_ip(ip)
    assert !was_found
    banned = BannedHost.new
    banned.remote_host_hash = GandhiTools.hash_remote_ip(ip)
    banned.save!
    was_found = BannedHost.find_by_ip(ip)
    assert was_found
  end

end

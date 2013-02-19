require 'test_helper'

class FailedAttemptLogTest < ActiveSupport::TestCase

  test "construct a failed attempt log" do
    ip = '131.253.13.32'
    result, log = FailedAttemptLog.construct!(ip)
    assert !result
    assert_not_nil log
    assert_equal log.attempt_count, 1
    assert_equal log.remote_host_hash, GandhiTools.hash_remote_ip(ip)
    result, log = FailedAttemptLog.construct!(ip)
    assert result
    assert log.attempt_count == 2
  end

end

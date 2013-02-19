class AddIndices < ActiveRecord::Migration
  def up
    add_index :failed_attempt_logs, :remote_host_hash
    add_index :banned_hosts, :remote_host_hash
  end

  def down
    remove_index :failed_attempt_logs, :remote_host_hash
    remove_index :banned_hosts, :remote_host_hash
  end
end

class BeTheChange < ActiveRecord::Migration

  def change
    create_table :messages do |t|
      t.text :encrypted_message, :null => false
      t.text :encrypted_passphrase, :null => false
      t.datetime :expires_at, :null => false
      t.datetime :viewed_at
      t.integer :destroy_after, :null => false  # number of seconds to wait before destroying the message
      t.timestamps
    end

    create_table :failed_attempt_logs do |t|
      t.string :remote_host_hash, :null => false
      t.integer :attempt_count, :null => false, :default => 1
      t.timestamps
    end

    create_table :banned_hosts do |t|
      t.string :remote_host_hash, :null => false
      t.timestamps
    end

  end

end

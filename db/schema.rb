# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130218064930) do

  create_table "banned_hosts", :force => true do |t|
    t.string   "remote_host_hash", :null => false
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "banned_hosts", ["remote_host_hash"], :name => "index_banned_hosts_on_remote_host_hash"

  create_table "failed_attempt_logs", :force => true do |t|
    t.string   "remote_host_hash",                :null => false
    t.integer  "attempt_count",    :default => 1, :null => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "failed_attempt_logs", ["remote_host_hash"], :name => "index_failed_attempt_logs_on_remote_host_hash"

  create_table "messages", :force => true do |t|
    t.text     "encrypted_message",    :null => false
    t.text     "encrypted_passphrase", :null => false
    t.datetime "expires_at",           :null => false
    t.datetime "viewed_at"
    t.integer  "destroy_after",        :null => false
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

end

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

ActiveRecord::Schema.define(:version => 20130227025708) do

  create_table "casts", :force => true do |t|
    t.integer  "user_id"
    t.string   "title",      :limit => 32
    t.integer  "price"
    t.integer  "free_time"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.string   "url"
  end

  create_table "casts_tags", :id => false, :force => true do |t|
    t.integer "cast_id"
    t.integer "tag_id"
  end

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "cast_id"
    t.string   "content",    :limit => 128
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tasks", :force => true do |t|
    t.integer  "user_id"
    t.string   "info"
    t.integer  "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name",       :limit => 8
    t.string   "password",   :limit => 64
    t.string   "salt",       :limit => 64
    t.string   "email",      :limit => 32
    t.integer  "score",                    :default => 100
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "url"
  end

end

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

ActiveRecord::Schema.define(:version => 20131204194027) do

  create_table "documents", :id => false, :force => true do |t|
    t.string  "ide",                             :null => false
    t.integer "rev",                             :null => false
    t.string  "typ",              :limit => 55,  :null => false
    t.text    "doc",                             :null => false
    t.string  "wfid"
    t.string  "participant_name", :limit => 512
  end

  add_index "documents", ["wfid"], :name => "documents_wfid_index"

  create_table "stack_outputs", :force => true do |t|
    t.string   "key"
    t.string   "value"
    t.text     "descr"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "stack_id"
  end

  create_table "stack_parameters", :force => true do |t|
    t.string   "param_name"
    t.string   "param_value"
    t.integer  "stack_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "stack_resources", :force => true do |t|
    t.string   "logical_id"
    t.string   "physical_id"
    t.integer  "stack_id"
    t.string   "status"
    t.string   "description"
    t.string   "typ"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "ruote_feid"
    t.text     "metadata"
  end

  create_table "stack_templates", :force => true do |t|
    t.string   "template_url"
    t.integer  "user_id"
    t.string   "template_name"
    t.text     "description"
    t.text     "body"
    t.string   "category"
    t.boolean  "public"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "stack_templates", ["public"], :name => "index_stack_templates_on_public"
  add_index "stack_templates", ["template_name"], :name => "index_stack_templates_on_template_name"

  create_table "stacks", :force => true do |t|
    t.string   "stack_id"
    t.integer  "user_id"
    t.string   "stack_name"
    t.string   "status"
    t.string   "reason"
    t.string   "description"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.integer  "stack_template_id"
    t.datetime "launched_at"
    t.string   "ruote_wfid"
    t.integer  "timeout",           :default => 600
  end

  add_index "stacks", ["stack_name"], :name => "index_stacks_on_stack_name"
  add_index "stacks", ["status"], :name => "index_stacks_on_status"
  add_index "stacks", ["user_id", "created_at"], :name => "index_stacks_on_user_id_and_created_at"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           :default => false
    t.string   "api_key"
    t.string   "sec_key"
    t.string   "cs_api_key"
    t.string   "cs_sec_key"
  end

  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end

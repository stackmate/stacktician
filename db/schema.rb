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

ActiveRecord::Schema.define(:version => 20130509004156) do

  create_table "stack_templates", :force => true do |t|
    t.string   "template_url"
    t.integer  "user_id"
    t.string   "template_name"
    t.string   "description"
    t.string   "body"
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
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "stack_template_id"
    t.datetime "launched_at"
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
  end

  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end

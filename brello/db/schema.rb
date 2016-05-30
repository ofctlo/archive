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

ActiveRecord::Schema.define(:version => 20130916145809) do

  create_table "boards", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
  end

  create_table "card_labels", :force => true do |t|
    t.integer  "card_id"
    t.integer  "label_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "cards", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.integer  "list_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "position"
    t.date     "due_date"
  end

  add_index "cards", ["list_id"], :name => "index_cards_on_list_id"

  create_table "checklist_items", :force => true do |t|
    t.string   "title"
    t.boolean  "completed"
    t.integer  "checklist_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "checklist_items", ["checklist_id"], :name => "index_checklist_items_on_checklist_id"

  create_table "checklists", :force => true do |t|
    t.string   "title"
    t.integer  "card_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "checklists", ["card_id"], :name => "index_checklists_on_card_id"

  create_table "labels", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "lists", :force => true do |t|
    t.string   "title"
    t.integer  "board_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "position"
  end

  add_index "lists", ["board_id"], :name => "index_lists_on_board_id"

  create_table "memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "board_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "memberships", ["board_id"], :name => "index_memberships_on_board_id"

  create_table "users", :force => true do |t|
    t.string   "fname"
    t.string   "lname"
    t.string   "email"
    t.string   "password_digest"
    t.string   "session_token"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.boolean  "guest"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["fname", "lname"], :name => "index_users_on_fname_and_lname"

end

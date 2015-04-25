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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150321010544) do

  create_table "accounts", force: true do |t|
    t.string   "name"
    t.integer  "init_amount"
    t.date     "init_date"
    t.integer  "current_amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "budget_plan_details", force: true do |t|
    t.date     "date"
    t.integer  "budget_id"
    t.string   "item_name"
    t.integer  "item_amount"
    t.string   "item_note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "budget_plans", force: true do |t|
    t.date     "date"
    t.integer  "usable_total"
    t.integer  "stock_total"
    t.integer  "budget_total"
    t.integer  "direct_debit"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "budgets", force: true do |t|
    t.date     "date"
    t.integer  "expense_item_id"
    t.integer  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cash_flows", force: true do |t|
    t.date     "date"
    t.integer  "account_id"
    t.string   "flow_type"
    t.integer  "amount"
    t.integer  "move_to"
    t.integer  "expense_item_id"
    t.text     "memo"
    t.boolean  "credit_card"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "expense_items", force: true do |t|
    t.string   "name"
    t.string   "expense_type"
    t.string   "category"
    t.integer  "sort"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end

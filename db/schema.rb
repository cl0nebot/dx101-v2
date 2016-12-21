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

ActiveRecord::Schema.define(version: 20141021170737) do

  create_table "aff_codes", force: true do |t|
    t.integer  "user_id"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "aff_codes", ["user_id"], name: "index_aff_codes_on_user_id"

  create_table "balances", force: true do |t|
    t.decimal  "amount",     precision: 16, scale: 8
    t.integer  "currency",                            default: 0, null: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "restricted", precision: 16, scale: 8
    t.integer  "curtype"
  end

  add_index "balances", ["user_id"], name: "index_balances_on_user_id"

  create_table "binary_orders", force: true do |t|
    t.integer  "user_id"
    t.integer  "binary_round_id"
    t.integer  "ordertype"
    t.integer  "direction"
    t.decimal  "premium",         precision: 16, scale: 8
    t.decimal  "prembalance",     precision: 16, scale: 8
    t.decimal  "pool",            precision: 16, scale: 8
    t.decimal  "sysbonus",        precision: 16, scale: 8
    t.decimal  "depbonus",        precision: 16, scale: 8
    t.decimal  "affpay",          precision: 16, scale: 8
    t.boolean  "itm"
    t.decimal  "itmpayout",       precision: 16, scale: 8
    t.decimal  "profit",          precision: 16, scale: 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "binary_orders", ["binary_round_id"], name: "index_binary_orders_on_binary_round_id"
  add_index "binary_orders", ["user_id"], name: "index_binary_orders_on_user_id"

  create_table "binary_rounds", force: true do |t|
    t.integer  "status"
    t.decimal  "open",       precision: 16, scale: 8
    t.decimal  "close",      precision: 16, scale: 8
    t.integer  "itm"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "pool_in",    precision: 16, scale: 8
    t.decimal  "pool_out",   precision: 16, scale: 8
    t.decimal  "callsum",    precision: 16, scale: 8
    t.decimal  "putsum",     precision: 16, scale: 8
    t.float    "payratio"
    t.integer  "roundtype"
    t.datetime "starttime"
    t.datetime "endtime"
  end

  create_table "bonus_pools", force: true do |t|
    t.integer  "bonustype"
    t.datetime "startday"
    t.decimal  "paid_in",    precision: 16, scale: 8
    t.decimal  "paid_out",   precision: 16, scale: 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "buy_bitcoins", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "buy_bitcoins", ["slug"], name: "index_buy_bitcoins_on_slug", unique: true

  create_table "crypto_addresses", force: true do |t|
    t.string   "address"
    t.integer  "currency"
    t.boolean  "active"
    t.integer  "addrtype"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "crypto_addresses", ["user_id"], name: "index_crypto_addresses_on_user_id"

  create_table "ext_quotes", force: true do |t|
    t.string   "source"
    t.integer  "pair",                                default: 0
    t.decimal  "val",        precision: 16, scale: 8
    t.datetime "quotetime"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"

  create_table "loans", force: true do |t|
    t.integer  "user_id"
    t.decimal  "amount",     precision: 16, scale: 8
    t.integer  "currency"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "loans", ["user_id"], name: "index_loans_on_user_id"

  create_table "pages", force: true do |t|
    t.string   "title"
    t.string   "meta"
    t.string   "slug"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["slug"], name: "index_pages_on_slug", unique: true

  create_table "pars", force: true do |t|
    t.integer  "user_id"
    t.datetime "date"
    t.integer  "rounds"
    t.integer  "activerounds"
    t.decimal  "premiums",       precision: 16, scale: 8
    t.integer  "wins"
    t.integer  "losses"
    t.float    "accuracy"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "p_percentile"
    t.decimal  "a_percentile"
    t.decimal  "r_percentile"
    t.integer  "rank"
    t.decimal  "score"
    t.decimal  "payout",         precision: 16, scale: 8
    t.integer  "period"
    t.integer  "bonus_pools_id"
  end

  add_index "pars", ["user_id"], name: "index_pars_on_user_id"

  create_table "profiles", force: true do |t|
    t.integer  "user_id"
    t.integer  "pin"
    t.string   "residence"
    t.string   "citizenship"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id"

  create_table "trades", force: true do |t|
    t.integer  "user_id"
    t.decimal  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trades", ["user_id"], name: "index_trades_on_user_id"

  create_table "txes", force: true do |t|
    t.integer  "txtype"
    t.decimal  "amount",        precision: 16, scale: 8
    t.integer  "currency"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "txid"
    t.integer  "status"
    t.integer  "confirmations"
    t.string   "address"
    t.datetime "complete_at"
    t.datetime "cancelled_at"
    t.string   "vin"
  end

  add_index "txes", ["user_id"], name: "index_txes_on_user_id"

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
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role",                   default: 0
    t.string   "username"
    t.string   "refid"
    t.datetime "tosdate"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  add_index "users", ["username"], name: "index_users_on_username", unique: true

end

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

ActiveRecord::Schema.define(version: 20131221105133) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "notebook_events", force: true do |t|
    t.integer  "notebook_id"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "notebook_events", ["notebook_id"], name: "index_notebook_events_on_notebook_id", using: :btree

  create_table "notebooks", force: true do |t|
    t.string   "name"
    t.string   "color"
    t.string   "paper_type"
    t.string   "carrier_identifier"
    t.integer  "user_id"
    t.hstore   "meta",                default: {}, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "notebook_identifier"
    t.string   "pdf"
    t.integer  "pages_count",         default: 0
    t.datetime "deleted_at"
  end

  add_index "notebooks", ["carrier_identifier"], name: "index_notebooks_on_carrier_identifier", using: :btree
  add_index "notebooks", ["notebook_identifier"], name: "index_notebooks_on_notebook_identifier", unique: true, using: :btree
  add_index "notebooks", ["user_id"], name: "index_notebooks_on_user_id", using: :btree

  create_table "oauth_access_grants", force: true do |t|
    t.integer  "resource_owner_id",              null: false
    t.integer  "application_id",                 null: false
    t.string   "token",                          null: false
    t.integer  "expires_in",                     null: false
    t.string   "redirect_uri",      limit: 2048, null: false
    t.datetime "created_at",                     null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: true do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        null: false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: true do |t|
    t.string   "name",                      null: false
    t.string   "uid",                       null: false
    t.string   "secret",                    null: false
    t.string   "redirect_uri", limit: 2048, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "pages", force: true do |t|
    t.integer  "number"
    t.string   "image"
    t.hstore   "meta",        default: {}
    t.integer  "notebook_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "pages", ["notebook_id"], name: "index_pages_on_notebook_id", using: :btree

  create_table "users", force: true do |t|
    t.hstore   "meta",                              default: {},    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                             default: "",    null: false
    t.string   "encrypted_password",                default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",                   default: 0,     null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "invitation_token",       limit: 60
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.boolean  "admin",                             default: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

end

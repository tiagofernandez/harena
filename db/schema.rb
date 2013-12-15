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

ActiveRecord::Schema.define(version: 20131211213128) do

  create_table "matches", force: true do |t|
    t.integer  "player1_id"
    t.integer  "player2_id"
    t.integer  "winner_id"
    t.string   "player1_team"
    t.string   "player2_team"
    t.string   "victory"
    t.integer  "map"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tournament_id"
    t.integer  "round"
    t.string   "pool"
  end

  add_index "matches", ["player1_id"], name: "index_matches_on_player1_id"
  add_index "matches", ["player2_id"], name: "index_matches_on_player2_id"
  add_index "matches", ["winner_id"], name: "index_matches_on_winner_id"

  create_table "players", force: true do |t|
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
    t.string   "username",               default: "", null: false
    t.integer  "avatar",                 default: 0,  null: false
    t.string   "timezone"
  end

  add_index "players", ["email"], name: "index_players_on_email", unique: true
  add_index "players", ["reset_password_token"], name: "index_players_on_reset_password_token", unique: true
  add_index "players", ["username"], name: "index_players_on_username", unique: true

  create_table "registrations", force: true do |t|
    t.integer "tournament_id"
    t.integer "player_id"
    t.boolean "accepted",      default: false, null: false
  end

  create_table "tournaments", force: true do |t|
    t.integer  "host_id"
    t.integer  "champion_id"
    t.integer  "runner_up_id"
    t.string   "title"
    t.string   "kind"
    t.string   "rules",        limit: 1024
    t.boolean  "started",                   default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tournaments", ["champion_id"], name: "index_tournaments_on_champion_id"
  add_index "tournaments", ["host_id"], name: "index_tournaments_on_host_id"
  add_index "tournaments", ["runner_up_id"], name: "index_tournaments_on_runner_up_id"

end

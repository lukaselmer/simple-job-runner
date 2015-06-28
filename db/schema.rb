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

ActiveRecord::Schema.define(version: 20150628193742) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "runs", force: :cascade do |t|
    t.json     "algo_parameters",              null: false
    t.datetime "started_at"
    t.datetime "ended_at"
    t.text     "output",          default: "", null: false
    t.float    "score"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "host_name",       default: "", null: false
  end

  add_index "runs", ["created_at"], name: "index_runs_on_created_at", using: :btree
  add_index "runs", ["ended_at"], name: "index_runs_on_ended_at", using: :btree
  add_index "runs", ["host_name"], name: "index_runs_on_host_name", using: :btree
  add_index "runs", ["started_at"], name: "index_runs_on_started_at", using: :btree

end

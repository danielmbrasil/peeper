# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_01_31_195349) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "follows", force: :cascade do |t|
    t.bigint "follower_id", null: false
    t.bigint "followed_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followed_id"], name: "index_follows_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_follows_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_follows_on_follower_id"
  end

  create_table "statuses", force: :cascade do |t|
    t.text "body", null: false
    t.bigint "user_id"
    t.bigint "status_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status_id"], name: "index_statuses_on_status_id"
    t.index ["user_id"], name: "index_statuses_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "handle", limit: 12, null: false
    t.string "display_name", limit: 30, null: false
    t.text "bio"
    t.date "born_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "statuses", "statuses"
end

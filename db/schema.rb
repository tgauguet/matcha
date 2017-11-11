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

ActiveRecord::Schema.define(version: 20171111134524) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "Application_record", force: :cascade do |t|
  end

  create_table "connections", force: :cascade do |t|
    t.bigint "user_id_id"
    t.boolean "blocked"
    t.boolean "visited"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id_id"], name: "index_connections_on_user_id_id"
  end

  create_table "conversations", force: :cascade do |t|
    t.integer "connection_id"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "images", force: :cascade do |t|
    t.integer "user_id"
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.boolean "main"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "interests", force: :cascade do |t|
    t.string "content"
    t.bigint "user_id_id"
    t.integer "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id_id"], name: "index_interests_on_user_id_id"
  end

  create_table "likes", force: :cascade do |t|
    t.bigint "user_id_id"
    t.integer "sender"
    t.integer "receiver"
    t.boolean "liked"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id_id"], name: "index_likes_on_user_id_id"
  end

  create_table "messages", force: :cascade do |t|
    t.integer "user_id"
    t.text "content"
    t.boolean "read"
    t.integer "conversation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "message_id"
    t.integer "identifier"
    t.string "type"
    t.boolean "read"
    t.bigint "conversation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id"], name: "index_notifications_on_conversation_id"
    t.index ["message_id"], name: "index_notifications_on_message_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "admin"
    t.string "name"
    t.string "firstname"
    t.string "password"
    t.string "password_confirmation"
    t.string "email"
    t.boolean "confirmed"
    t.boolean "gender"
    t.string "state"
    t.string "country"
    t.string "street"
    t.text "bio"
    t.string "interested_in"
    t.string "city"
    t.integer "tag_id"
    t.integer "interest_id"
    t.integer "score"
    t.float "latitude"
    t.boolean "fake_account"
    t.float "longitude"
    t.integer "connection_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "login"
    t.string "password_digest"
    t.boolean "email_confirmed", default: false
    t.string "confirm_token"
    t.string "password_token"
  end

  add_foreign_key "notifications", "conversations"
  add_foreign_key "notifications", "messages"
  add_foreign_key "notifications", "users"
end

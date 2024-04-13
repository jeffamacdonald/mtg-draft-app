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

ActiveRecord::Schema[7.0].define(version: 2024_04_13_053009) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cards", force: :cascade do |t|
    t.string "name", null: false
    t.string "cost"
    t.integer "cmc", null: false
    t.string "type_line", null: false
    t.string "card_text"
    t.string "layout"
    t.integer "power"
    t.integer "toughness"
    t.string "default_image", null: false
    t.string "default_set", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "color_identity", null: false, array: true
    t.index ["card_text"], name: "index_cards_on_card_text"
    t.index ["cmc"], name: "index_cards_on_cmc"
    t.index ["name"], name: "index_cards_on_name", unique: true
    t.index ["power"], name: "index_cards_on_power"
    t.index ["toughness"], name: "index_cards_on_toughness"
  end

  create_table "cube_cards", force: :cascade do |t|
    t.bigint "cube_id"
    t.bigint "card_id"
    t.integer "count", null: false
    t.string "custom_set"
    t.string "custom_image"
    t.integer "custom_cmc"
    t.boolean "soft_delete", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "custom_color_identity", array: true
    t.index ["card_id"], name: "index_cube_cards_on_card_id"
    t.index ["cube_id", "card_id"], name: "index_cube_cards_on_cube_id_and_card_id", unique: true
    t.index ["cube_id"], name: "index_cube_cards_on_cube_id"
    t.index ["soft_delete"], name: "index_cube_cards_on_soft_delete"
  end

  create_table "cubes", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_cubes_on_name"
    t.index ["user_id"], name: "index_cubes_on_user_id"
  end

  create_table "draft_participants", force: :cascade do |t|
    t.bigint "draft_id"
    t.bigint "user_id"
    t.bigint "surrogate_user_id"
    t.string "display_name"
    t.integer "draft_position"
    t.boolean "skipped"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["draft_id", "draft_position"], name: "index_draft_participants_on_draft_id_and_draft_position", unique: true
    t.index ["draft_id", "user_id"], name: "index_draft_participants_on_draft_id_and_user_id", unique: true
    t.index ["draft_id"], name: "index_draft_participants_on_draft_id"
    t.index ["surrogate_user_id"], name: "index_draft_participants_on_surrogate_user_id"
    t.index ["user_id"], name: "index_draft_participants_on_user_id"
  end

  create_table "drafts", force: :cascade do |t|
    t.bigint "cube_id"
    t.bigint "user_id"
    t.string "name", null: false
    t.integer "rounds", null: false
    t.integer "timer_minutes"
    t.string "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cube_id"], name: "index_drafts_on_cube_id"
    t.index ["name"], name: "index_drafts_on_name"
    t.index ["status"], name: "index_drafts_on_status"
    t.index ["user_id"], name: "index_drafts_on_user_id"
  end

  create_table "participant_picks", force: :cascade do |t|
    t.bigint "draft_participant_id"
    t.bigint "cube_card_id"
    t.integer "pick_number", null: false
    t.integer "round", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cube_card_id"], name: "index_participant_picks_on_cube_card_id"
    t.index ["draft_participant_id"], name: "index_participant_picks_on_draft_participant_id"
    t.index ["round"], name: "index_participant_picks_on_round"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "username"
    t.string "phone"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "cube_cards", "cards"
  add_foreign_key "cube_cards", "cubes"
  add_foreign_key "cubes", "users"
  add_foreign_key "draft_participants", "drafts"
  add_foreign_key "draft_participants", "users"
  add_foreign_key "draft_participants", "users", column: "surrogate_user_id"
  add_foreign_key "drafts", "cubes"
  add_foreign_key "drafts", "users"
  add_foreign_key "participant_picks", "cube_cards"
  add_foreign_key "participant_picks", "draft_participants"
end

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

ActiveRecord::Schema[7.1].define(version: 2025_01_24_071426) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "cards", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "cost"
    t.integer "cmc", null: false
    t.string "color_identity", null: false, array: true
    t.string "type_line", null: false
    t.string "card_text"
    t.string "layout"
    t.integer "power"
    t.integer "toughness"
    t.string "default_image", null: false
    t.string "default_set", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_text"], name: "index_cards_on_card_text"
    t.index ["cmc"], name: "index_cards_on_cmc"
    t.index ["color_identity"], name: "index_cards_on_color_identity"
    t.index ["name"], name: "index_cards_on_name", unique: true
    t.index ["power"], name: "index_cards_on_power"
    t.index ["toughness"], name: "index_cards_on_toughness"
  end

  create_table "cube_cards", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "cube_id"
    t.uuid "card_id"
    t.integer "count", null: false
    t.string "custom_set", null: false
    t.string "custom_image", null: false
    t.string "custom_color_identity", null: false, array: true
    t.integer "custom_cmc", null: false
    t.boolean "soft_delete", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_cube_cards_on_card_id"
    t.index ["cube_id"], name: "index_cube_cards_on_cube_id"
    t.index ["custom_color_identity"], name: "index_cube_cards_on_custom_color_identity"
    t.index ["soft_delete"], name: "index_cube_cards_on_soft_delete"
  end

  create_table "cubes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_cubes_on_name"
    t.index ["user_id"], name: "index_cubes_on_user_id"
  end

  create_table "draft_chat_messages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.uuid "draft_id"
    t.string "text", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "participant_pick_id"
    t.index ["draft_id"], name: "index_draft_chat_messages_on_draft_id"
    t.index ["participant_pick_id"], name: "index_draft_chat_messages_on_participant_pick_id"
    t.index ["user_id"], name: "index_draft_chat_messages_on_user_id"
  end

  create_table "draft_participants", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "draft_id"
    t.uuid "user_id"
    t.uuid "surrogate_user_id"
    t.string "display_name", null: false
    t.integer "draft_position"
    t.boolean "skipped", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["draft_id", "draft_position"], name: "index_draft_participants_on_draft_id_and_draft_position", unique: true
    t.index ["draft_id", "user_id"], name: "index_draft_participants_on_draft_id_and_user_id", unique: true
    t.index ["draft_id"], name: "index_draft_participants_on_draft_id"
    t.index ["surrogate_user_id"], name: "index_draft_participants_on_surrogate_user_id"
    t.index ["user_id"], name: "index_draft_participants_on_user_id"
  end

  create_table "drafts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "cube_id"
    t.uuid "user_id"
    t.string "name", null: false
    t.integer "rounds", null: false
    t.integer "timer_minutes"
    t.string "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "active_round"
    t.datetime "last_pick_at"
    t.index ["cube_id"], name: "index_drafts_on_cube_id"
    t.index ["name"], name: "index_drafts_on_name"
    t.index ["status"], name: "index_drafts_on_status"
    t.index ["user_id"], name: "index_drafts_on_user_id"
  end

  create_table "participant_picks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "draft_participant_id"
    t.uuid "cube_card_id"
    t.integer "pick_number", null: false
    t.integer "round", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cube_card_id"], name: "index_participant_picks_on_cube_card_id"
    t.index ["draft_participant_id"], name: "index_participant_picks_on_draft_participant_id"
    t.index ["round"], name: "index_participant_picks_on_round"
  end

  create_table "surrogate_draft_participants", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "draft_participant_id"
    t.uuid "surrogate_participant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["draft_participant_id"], name: "index_surrogate_draft_participants_on_draft_participant_id"
    t.index ["surrogate_participant_id"], name: "index_surrogate_draft_participants_on_surrogate_participant_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "username"
    t.string "phone"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.string "default_display", default: "image", null: false
    t.string "default_image_size", default: "lg", null: false
    t.string "pick_list_size", default: "", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
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
  add_foreign_key "surrogate_draft_participants", "draft_participants"
  add_foreign_key "surrogate_draft_participants", "draft_participants", column: "surrogate_participant_id"
end

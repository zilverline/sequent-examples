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

ActiveRecord::Schema[7.0].define(version: 2019_11_02_144124) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: :cascade do |t|
    t.string "title"
    t.text "text"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "command_records", force: :cascade do |t|
    t.string "user_id"
    t.string "aggregate_id"
    t.string "command_type", null: false
    t.text "command_json", null: false
    t.datetime "created_at", null: false
  end

  create_table "event_records", force: :cascade do |t|
    t.string "aggregate_id", null: false
    t.integer "sequence_number", null: false
    t.datetime "created_at", null: false
    t.string "event_type", null: false
    t.text "event_json", null: false
    t.integer "command_record_id", null: false
    t.integer "stream_record_id", null: false
    t.index "aggregate_id, sequence_number, (\nCASE event_type\n    WHEN 'Sequent::Core::SnapshotEvent'::text THEN 0\n    ELSE 1\nEND)", name: "unique_event_per_aggregate", unique: true
    t.index ["aggregate_id", "sequence_number"], name: "snapshot_events", order: { sequence_number: :desc }, where: "((event_type)::text = 'Sequent::Core::SnapshotEvent'::text)"
    t.index ["command_record_id"], name: "index_event_records_on_command_record_id"
    t.index ["created_at"], name: "index_event_records_on_created_at"
    t.index ["event_type"], name: "index_event_records_on_event_type"
  end

  create_table "post_records_3", id: :serial, force: :cascade do |t|
    t.uuid "aggregate_id", null: false
    t.string "author"
    t.string "title"
    t.string "content"
    t.index ["aggregate_id"], name: "post_records_keys_3", unique: true
  end

  create_table "sequent_replayed_ids", primary_key: "event_id", id: :bigint, default: nil, force: :cascade do |t|
  end

  create_table "sequent_versions", primary_key: "version", id: :integer, default: nil, force: :cascade do |t|
  end

  create_table "stream_records", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "aggregate_type", null: false
    t.string "aggregate_id", null: false
    t.integer "snapshot_threshold"
    t.index ["aggregate_id"], name: "index_stream_records_on_aggregate_id", unique: true
  end

  add_foreign_key "event_records", "command_records", name: "command_fkey"
  add_foreign_key "event_records", "stream_records", name: "stream_fkey"
end

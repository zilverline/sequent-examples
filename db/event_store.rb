require_relative 'version'

ActiveRecord::Schema.define(:version => SCHEMA_VERSION) do

  create_table "command_records", :force => true do |t|
    t.string "organization_id"
    t.string "user_id"
    t.string "aggregate_id"
    t.string "command_type", :null => false
    t.text "command_json", :null => false
    t.datetime "created_at", :null => false
  end

  create_table "event_records", :force => true do |t|
    t.string "aggregate_id", :null => false
    t.string "organization_id"
    t.integer "sequence_number", :null => false
    t.datetime "created_at", :null => false
    t.string "event_type", :null => false
    t.text "event_json", :null => false
    t.integer "command_record_id", :null => false
  end

  add_index "event_records", ["aggregate_id", "sequence_number"], :name => "unique_event_per_aggregate", :unique => true
  add_index "event_records", ["command_record_id"], :name => "index_event_records_on_command_record_id"
  add_index "event_records", ["organization_id"], :name => "index_event_records_on_organization_id"
  add_index "event_records", ["event_type"], :name => "index_event_records_on_event_type"
  add_index "event_records", ["created_at"], :name => "index_event_records_on_created_at"

end

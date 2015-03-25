require_relative 'version'

ActiveRecord::Schema.define(:version => SCHEMA_VERSION) do

  create_table "invoice_records", :force => true do |t|
    t.string "aggregate_id", :null => false
    t.string "organization_id", :null => false
    t.integer "sequence_number", :null => false
  end

  add_index "invoice_records", ["aggregate_id"], :name => "unique_aggregate_id_for_invoice", :unique => true

end

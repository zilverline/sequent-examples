require_relative '../config/sequent_app'

Sequent::Support::ViewSchema.define(view_projection: SequentApp::VIEW_PROJECTION) do
  create_table :invoice_records, :force => true do |t|
    t.string :aggregate_id, :null => false
    t.string :tenant_id, :null => false
    t.integer :amount
    t.string :recipient_name
  end

  add_index :invoice_records, ["aggregate_id"], :name => "unique_aggregate_id_for_invoice", :unique => true
end

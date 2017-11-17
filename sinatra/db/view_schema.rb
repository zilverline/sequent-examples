require_relative '../invoicing_app'

Sequent::Support::ViewSchema.define(view_projection: InvoicingApp::VIEW_PROJECTION) do
  create_table :invoice_records, :force => true do |t|
    t.string :aggregate_id, :null => false
    t.string :tenant_id, :null => false
    t.integer :amount
    t.string :recipient_name
  end

  add_index :invoice_records, ["aggregate_id"], :name => "unique_aggregate_id_for_invoice", :unique => true

  create_table :invoice_totals_records, :force => true do |t|
    t.string :tenant_id, :null => false
    t.integer :total_invoice_count
    t.integer :total_amount
  end
end

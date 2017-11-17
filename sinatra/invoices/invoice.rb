require 'sequent'
require_relative 'value_objects'

class Invoice < Sequent::Core::TenantAggregateRoot

  def initialize(id, organization_id, amount, recipient)
    super id, organization_id
    apply InvoiceCreatedEvent, amount: amount, recipient: recipient
  end

  def pay(date)
    raise "date must be provided" if date.nil?
    raise "already paid" if @outstanding_amount == 0
    apply InvoicePaidEvent, paid_at: date
  end

  private
  on InvoiceCreatedEvent do |event|
    @outstanding_amount = event.amount
  end

  on InvoicePaidEvent do |_|
    @outstanding_amount = 0
  end

end


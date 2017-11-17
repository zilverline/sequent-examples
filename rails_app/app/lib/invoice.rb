class Invoice < TenantAggregateRoot

  def initialize(id, tenant_id, amount, recipient)
    super id, tenant_id
    apply InvoiceCreated, amount: amount, recipient: recipient
  end

  def pay(date)
    raise "date must be provided" if date.nil?
    raise "already paid" if @outstanding_amount == 0
    apply InvoicePaid, paid_at: date
  end

  private
  on InvoiceCreated do |event|
    @outstanding_amount = event.amount
  end

  on InvoicePaid do |_|
    @outstanding_amount = 0
  end

end


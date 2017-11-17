class InvoicePaid < TenantEvent
  attrs paid_at: Date
end

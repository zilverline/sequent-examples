require 'active_record'

class InvoiceRecord < ActiveRecord::Base

end

class InvoiceTotalsRecord < ActiveRecord::Base

end

class EventRecord < Sequent::Core::EventRecord
  def self.created_organizations
    EventRecord.pluck(:organization_id).uniq
  end
end

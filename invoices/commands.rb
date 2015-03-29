require_relative 'value_objects'

module InvoiceCommand

end

class CreateInvoiceCommand < Sequent::Core::TenantCommand
  include Sequent::Core::Helpers::StringSupport
  include ActiveModel::Validations::Callbacks
  include InvoiceCommand

  attrs amount: Integer, recipient: Recipient

  validates_numericality_of :amount
  validates_presence_of :amount
  validates_presence_of :recipient

  # todo: move to sequent
  # sequent should take care of converting to the correct types.
  after_validation :parse_values

  def parse_values
    attributes.each do |name, type|
      if type == Integer
        raw_value = self.instance_variable_get("@#{name}")
        self.instance_variable_set("@#{name}", raw_value.to_i) unless raw_value.nil?
      end
    end
  end
end

class PayInvoiceCommand < Sequent::Core::TenantCommand
  include Sequent::Core::Helpers::StringSupport
  include InvoiceCommand
  attrs pay_date: DateTime

  validates_presence_of :pay_date
end

require_relative 'value_objects'

class CreateInvoiceCommand < Sequent::Core::Command
  attrs amount: Integer, recipient: String

  validates_presence_of :amount
  validates_presence_of :recipient
end

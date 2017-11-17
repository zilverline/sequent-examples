class Recipient < Sequent::Core::ValueObject
  attrs name: String
  validates_presence_of :name
end

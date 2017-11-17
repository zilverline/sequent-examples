class TenantCommand < Sequent::Core::Command
  attrs tenant_id: String
  validates_presence_of :tenant_id
end

class TenantAggregateRoot < Sequent::Core::AggregateRoot
  attr_reader :tenant_id

  def initialize(id, tenant_id)
    super(id)
    raise ArgumentError.new('tenant_id can not be nil') unless tenant_id
    @tenant_id = tenant_id
  end

  def load_from_history(stream, events)
    raise "Empty history" if events.empty?
    @tenant_id = events.first.tenant_id
    super
  end

  protected
  # called by apply. Here we can put in the organization_id for all
  # aggregate roots needing the tenant_id
  def build_event(event, params = {})
    super(event, params.merge({tenant_id: @tenant_id}))
  end
end


class InvoiceController < ApplicationController

  TENANT_ID = 'example_tenant'

  def new
    @command = CreateInvoice.new(
      aggregate_id: Sequent.new_uuid,
      tenant_id: TENANT_ID
    )
  end

  def create
    @command = CreateInvoice.from_params(create_invoice_params)

    begin
      Sequent.command_service.execute_commands(@command)
      redirect_to invoice_index_path
    rescue Sequent::Core::CommandNotValid
      render :new # render same page and display error
    end
  end

  def create_invoice_params
    params.require(:create_invoice).permit(:aggregate_id, :amount, :tenant_id, recipient: [:name])
  end
end

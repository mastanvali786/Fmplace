require 'paypal-sdk-invoice'

module PayPalInvoiceSdk

  def self.mark_paid!(invoice_id, paid_on=DateTime.now)
    result = mark_paid(invoice_id, paid_on)
    unless result.success?
      raise "PayPal Invoice Sdk: #{result.error}"
    end
  end

  def self.mark_paid(invoice_id, paid_on=DateTime.now)
    mark_as_paid = api.build_mark_invoice_as_paid({
                                                  :invoiceID => invoice_id,
                                                  :payment => {
                                                    :method => "PayPal",
                                                    :date => paid_on}
                                                 })
    api.mark_invoice_as_paid mark_as_paid
  end

  def self.invoice_details(invoice_id)
    get_details = api.build_get_invoice_details invoiceID: invoice_id
    InvoiceDetails.new api.get_invoice_details get_details
  end

  def self.create_milestone_invoice(payerEmail, milestone)
    milestones = milestone.is_a?(Array) ? milestone : [milestone]
    items = milestones.map do |milestone|
      name = "Milestone #{milestone.id}"
      unitPrice = milestone.price.to_f
      quantity = 1
      Item.new(name.html_safe, unitPrice, quantity).to_h
    end
    create payerEmail, items
  end
  private
  class InvoiceDetails
    attr_accessor :details
    def initialize(response)
      @response = response
      @details = response.invoiceDetails
    end
    def success?
      @response.success?
    end
    def error
      @response.error
    end
    def paid?
      details.status.downcase.match /paid/
    end
    def paid_on
      details.paidDate
    end
  end
  Item = Struct.new :name, :unitPrice, :quantity
  def self.create(payer_email, items, merchant_email=AppConfig.app.sdk.paypal.merchant_email)
    invoice = api.build_create_and_send_invoice({
       :invoice => {
         :merchantEmail => merchant_email,
         :payerEmail => payer_email,
         :itemList => {
           :item => items
         },
         :currencyCode => "USD",
         :paymentTerms => "NoDueDate" } })
    api.create_and_send_invoice(invoice)
  end
  def self.api
    @@api ||= PayPal::SDK::Invoice::API.new
  end
end
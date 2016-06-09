module Listeners
  class PaymentsListener
    extend Helper
    include Messageable
    def new_transaction payment
      PaymentBalance.create! payment_id:payment.id, balance:payment.receiver.balance.current
      notify_recipient payment
      broadcast("new_#{payment.klass.underscore}_payment", payment)
    end
    def self.notify_new_payment_transaction payment
      payment_type = payment.type
      template = <<-EOL
        A #{link_to payment_type.downcase, "/payments/" + payment.id.to_s} for #{ helpers.number_to_currency payment.amount } has been made to your account.
      EOL
      subject = "New #{payment_type.titleize} Transaction"
      send_admin_message subject, template, payment.to
    end
    private
    def notify_recipient payment
      PaymentsListener.notify_new_payment_transaction payment
    end
  end
end
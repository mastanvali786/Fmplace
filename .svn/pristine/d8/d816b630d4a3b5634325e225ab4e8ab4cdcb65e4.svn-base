require 'paypal-sdk-adaptivepayments'

module PayPalPaymentsSdk
  def self.get_details pay_key
    details = api.build_payment_details({
                                :payKey => pay_key
                              })
    PaymentDetails.new api.payment_details details
  end
  #ARGS: :receiver_email, :amount, :invoice_id, :return_url, :ipn_url
  def self.paymentRequestUrl(args={})
    unless PAYMENT_ARGS_CONSTRAINTS.all? {|constraint|args.key?(constraint)}
      raise "Payment args must be hash a with keys: #{PAYMENT_ARGS_CONSTRAINTS.to_sentence}"
    end
    _args = OpenStruct.new args
    pay = api.build_pay({
                            :actionType => "PAY",
                            :cancelUrl => _args.return_url,
                            :currencyCode => "USD",
                            :feesPayer => "SENDER",
                            :reverseAllParallelPaymentsOnError => true,
                            :ipnNotificationUrl => _args.ipn_url,
                            :receiverList => {
                              :receiver => [{
                                              :amount => _args.amount,
                                              :email =>_args.receiver_email,
                                              :invoiceId => _args.invoice_id
                                            }]
                            },
                            :returnUrl => _args.return_url,
                            :fundingConstraint => {
                              :allowedFundingType => {
                                :fundingTypeInfo => [{
                                  :fundingType => "ECHECK"
                                }]
                              }
                            }
    })
    PaymentResponse.new api.pay(pay), api
  end
  private
    PAYMENT_ARGS_CONSTRAINTS=[:receiver_email, :amount, :invoice_id, :return_url, :ipn_url]
    class PaymentDetails
      attr_accessor :success, :error
      def initialize response
        @success = response.success?
        @error = response.error
        @info = response.paymentInfoList.paymentInfo.first
      end
      def success?
        @success
      end
      def paid?
        @info.transactionStatus == "COMPLETED"
      end
      def transactionId
        @info.transactionId
      end
    end
    class PaymentResponse
      attr_accessor :payKey, :status
      def initialize(response, api)
        @response = response
        @api = api
      end
      def error
        @response.error[0].message
      end
      def success?
        @response.success?
      end
      def pay_key
        @response.payKey
      end
      def payerViewUrl
        @api.payment_url(@response)
      end
    end
  def self.api
    @@api ||= PayPal::SDK::AdaptivePayments::API.new
  end
end
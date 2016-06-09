class PaymentType < ActiveRecord::Base

	# Associations
	has_many :account_settings
	has_one :payment_setting
	scope :active_payments, -> { where(active: true) }
	scope :authorize, -> { where(name: "AUTHORIZECREDITCARD") }
	scope :payfast, -> { where(name: "PAYFAST") }
	scope :paypal, -> { where(name: "PAYPAL") }
	scope :braintree, -> { where(name: "BRAINTREE") }
	validates :display_name, :presence => true

  #Authorize Payment Getways
  def self.authorize_net_payment
  	PaymentType.authorize.first
  end

  def self.authorize_net_payment_settings
  	authorize_net_payment.payment_setting
  end

  def self.authorize_api_login_id
  	authorize_net_payment_settings.value1
  end

  def self.authorize_api_transaction_key
  	authorize_net_payment_settings.value2
  end

  def self.authorize_mode_url
  	"https://test.authorize.net/gateway/transact.dll"
  end

	#Payfast Payment Getways

	def self.payfast_payment
		PaymentType.payfast.first
	end

	def self.payfast_payment_settings
		payfast_payment.payment_setting
	end

	def self.payfast_merchant_id
		payfast_payment_settings.value1.to_i
	end

	def self.payfast_merchant_key
		payfast_payment_settings.value2
	end

	def self.payfast_mode_url
  	"https://sandbox.payfast.co.za/eng/process"
  end

  #Briantree Payment Getways

  def self.braintree_payment
		PaymentType.braintree.first
	end

	def self.braintree_payment_settings
		braintree_payment.payment_setting
	end

	def self.braintree_private_key
		braintree_payment_settings.value1
	end

	def self.braintree_public_key
		braintree_payment_settings.value2
	end

	def self.braintree_merchant_id
		braintree_payment_settings.value3
	end

	def self.braintree_mode_url
  	"https://sandbox.payfast.co.za/eng/process"
  end
# paypal payment gateways
def self.paypal_payment
		PaymentType.paypal.first
	end

	def self.paypal_payment_settings
		paypal_payment.payment_setting
	end
	def self.paypal_merchant_email
		paypal_payment_settings.value1
	end
end
class AccountSetting < ActiveRecord::Base
	belongs_to :user
	belongs_to :payment_type

	# Delegate
	delegate :name, to: :payment_type, prefix: true, allow_nil: true
end

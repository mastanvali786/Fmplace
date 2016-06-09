class PaymentDetail < ActiveRecord::Base
  validates :payment_id, :data, presence: true
  belongs_to :payment
  store :data

  def request_id
  	data[:request_id] if data
  end

  def transaction_id
  	data[:transaction_id] if data
  end

  def release_request
  	MilestoneReleaseFundRequest.find_by_id(request_id)
  end
end
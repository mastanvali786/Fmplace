class BidMilestone < ActiveRecord::Base
  belongs_to :bid
  validates :description, :delivery_date, :price, presence: true
end
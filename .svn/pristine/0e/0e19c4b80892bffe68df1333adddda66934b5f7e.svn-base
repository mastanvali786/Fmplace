class MembershipPlan < ActiveRecord::Base
	has_many :user_membership_plan

	has_many :users, through: :user_membership_plan

	after_update :update_all_the_sellers, :if => :connects_changed?

	validates :name, presence: true, on: :update
	validates :amount,:numericality => { :greater_than_or_equal_to => 0, :only_integer => true}, presence: true, on: :update
	validates :highlight_skills,:numericality => { :greater_than_or_equal_to => 1, :only_integer => true}, presence: true, on: :update
	validates :team_count, presence: true, on: :update
	validates :connects, presence: true,:numericality => { :greater_than_or_equal_to => 1, :only_integer => true} , on: :update
	validates :service_fee, presence: true,:numericality => { :greater_than_or_equal_to => 1, :only_integer => true}, on: :update

	def update_all_the_sellers
		users = self.users
		users.each do |user|
			user.update_attributes(total_connects: self.connects.to_i)
		end
	end
end

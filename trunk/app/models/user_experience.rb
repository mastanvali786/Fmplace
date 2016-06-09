class UserExperience < ActiveRecord::Base

	# Associations
	belongs_to :user

	# Validation
	validates :company_name, presence: true
	validates :job_title, presence: true
	validates :start_date, presence: true
	validates :end_date, presence: true
	validates :description, presence: true
end

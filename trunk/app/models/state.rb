class State < ActiveRecord::Base
	belongs_to :country
	has_many :projects

	def name
		state_name
	end
end

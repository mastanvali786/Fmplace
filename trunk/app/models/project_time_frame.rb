class ProjectTimeFrame < ActiveRecord::Base

	# Associations

	has_many :projects
	validates :name, :presence => true
end

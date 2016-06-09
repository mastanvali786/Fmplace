class ProjectBudget < ActiveRecord::Base
	has_many :projects
	has_many :budget_options
	validates :name, :presence => true
end

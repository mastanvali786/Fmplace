class BudgetOption < ActiveRecord::Base
	has_many :projects
	belongs_to :project_budget

	# Delegates
	delegate :name, to: :project_budget, prefix: true, allow_nil: true
end

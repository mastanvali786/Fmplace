class Country < ActiveRecord::Base
	has_many :states
	has_many :projects
	has_many :testimonials
end

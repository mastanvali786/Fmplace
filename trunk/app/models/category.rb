class Category < ActiveRecord::Base
	has_many :subcategories
	has_many :projects
	validates :name, :presence => true
end

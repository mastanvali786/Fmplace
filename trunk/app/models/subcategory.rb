class Subcategory < ActiveRecord::Base
	belongs_to :category
	has_many :projects
	validates :name, :category_id, :presence => true
end

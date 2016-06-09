class Dispute < ActiveRecord::Base
	belongs_to :user
	belongs_to :project
	validates :subject, :presence => true
	validates :body, :presence => true
end

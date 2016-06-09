class RegularFaq < ActiveRecord::Base
	
	scope :sellers_questions, -> { where(role: 1) }
  scope :buyers_questions, ->  { where(role: 2) }

end

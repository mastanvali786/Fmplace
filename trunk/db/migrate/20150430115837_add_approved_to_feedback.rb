class AddApprovedToFeedback < ActiveRecord::Migration
  def change
  	add_column :feedbacks, :approved, :boolean, default: false
  end
end

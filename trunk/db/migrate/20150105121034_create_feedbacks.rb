class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
    	t.integer :project_id
    	t.integer :from_id
    	t.integer :to_id
    	t.integer :aggregate
    	t.integer :quality_work
    	t.integer :responsiveness
    	t.integer :professionalism
    	t.integer :expertise
    	t.integer :cost
    	t.integer :schedule
      t.text :comment
      t.integer :guest_user_id
      t.timestamps
    end
  end
end

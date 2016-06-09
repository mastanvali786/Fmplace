class CreateUserExperiences < ActiveRecord::Migration
  def change
    create_table :user_experiences do |t|
      t.integer :user_id
      t.string	:company_name
      t.string	:job_title
      t.date	:start_date
      t.date 	:end_date
      t.text	:description 
      t.timestamps
    end

    add_index :user_experiences, :user_id
  end
end

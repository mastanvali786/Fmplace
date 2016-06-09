class CreateUserEducations < ActiveRecord::Migration
  def change
    create_table :user_educations do |t|
      t.integer :user_id
      t.string	:college_name
      t.date	:start_date
      t.date 	:end_date
      t.integer :degree_id
      t.string	:field_of_study
      t.text	:activities_societies
      t.text	:description
      t.timestamps
    end

    add_index :user_educations, :user_id
    add_index :user_educations, :degree_id
  end
end

class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.text   :description
      t.string :project_photo
      t.integer :category_id
      t.integer :subcategory_id
      t.string  :project_tag_ids
      t.string  :skill_tags_ids
      t.integer :budget_option_id
      t.integer :project_time_frame_id
      t.datetime :start_date
      t.datetime :end_date
      t.integer :country_id
      t.integer :state_id
      t.string :city
      t.integer :zip_code
      t.integer :user_id
      t.boolean :visible, default: true
      t.timestamps
    end
  end
end
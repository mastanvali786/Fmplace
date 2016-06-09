class CreateProjectFiles < ActiveRecord::Migration
  def change
    create_table :project_files do |t|
      t.belongs_to :project
      t.belongs_to :user
      t.string :file
      t.string :file_name
      t.string :content_type
      t.integer :file_size
      t.timestamps
    end
  end
end

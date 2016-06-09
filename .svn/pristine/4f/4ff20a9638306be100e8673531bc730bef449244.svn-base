class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.integer :project_id
      t.string :file_name
      t.string :attach_type
      t.integer :user_id
      t.integer :bid_id
      t.timestamps
    end
  end
end

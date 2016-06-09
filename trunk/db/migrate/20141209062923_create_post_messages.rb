class CreatePostMessages < ActiveRecord::Migration
  def change
    create_table :post_messages do |t|
      t.string :message
      t.integer :user_id
      t.integer :project_id
      t.timestamps
    end
  end
end

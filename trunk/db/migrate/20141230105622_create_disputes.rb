class CreateDisputes < ActiveRecord::Migration
  def change
    create_table :disputes do |t|
      t.string :subject
      t.text :body
      t.integer :project_id
      t.integer :user_id
      t.timestamps
    end
  end
end

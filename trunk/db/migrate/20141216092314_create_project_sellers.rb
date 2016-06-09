class CreateProjectSellers < ActiveRecord::Migration
  def change
    create_table :project_sellers do |t|
      t.integer :project_id
      t.integer :user_id
      t.integer :bid_id
      t.timestamps
    end
  end
end

class CreateMilestones < ActiveRecord::Migration
  def change
    create_table :milestones do |t|
      t.string :description
      t.datetime :delivery_date
      t.string :price
      t.string :note
      t.integer :project_id
      t.string  :status, default:"pending"
      t.integer :created_by
      t.integer :buyer_id
      t.integer :seller_id
      t.string :current_url
      t.string :paypal_ipn_url
      t.timestamps
    end
  end
end

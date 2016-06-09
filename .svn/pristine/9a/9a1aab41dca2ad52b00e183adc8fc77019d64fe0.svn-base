class CreateBidMilestones < ActiveRecord::Migration
  def change
    create_table :bid_milestones do |t|
      t.string :description
      t.references :bid
      t.integer :price
      t.date :delivery_date
    end
  end
end

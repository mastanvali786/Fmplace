class CreateMilestoneReleaseFundRequests < ActiveRecord::Migration
  def change
    create_table :milestone_release_fund_requests do |t|
      t.belongs_to :buyer
      t.belongs_to :seller
      t.belongs_to :milestone
      t.boolean :released, default:false
      t.string :amount
      t.timestamps
    end
  end
end

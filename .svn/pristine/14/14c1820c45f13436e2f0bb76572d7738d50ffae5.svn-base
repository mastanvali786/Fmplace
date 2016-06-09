class CreateMilestoneFundingRequests < ActiveRecord::Migration
  def change
    create_table :milestone_funding_requests do |t|
      t.belongs_to :user
      t.belongs_to :milestone
      t.date :sent_at
      t.string :type, default: "PayPal"
    end
  end
end

class CreateFundingRequests < ActiveRecord::Migration
  def change
    create_table :funding_requests do |t|
      t.belongs_to :user
      t.belongs_to :milestone
      t.date :sent_at
      t.string :status
      t.string :type, default: "PayPal"
    end
  end
end

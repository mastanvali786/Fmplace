class CreateDepositRequests < ActiveRecord::Migration
  def change
    create_table :deposit_requests do |t|
      t.belongs_to :user
      t.belongs_to :balance
      t.string :amount
      t.string :status, default: "Pending"
      t.string :type, default: "PayPal"
      t.timestamps
    end
  end
end

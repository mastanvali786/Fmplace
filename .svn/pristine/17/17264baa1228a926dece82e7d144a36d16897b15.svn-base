class CreateWithdrawalRequests < ActiveRecord::Migration
  def change
    create_table :withdrawal_requests do |t|
    	t.belongs_to :user
      t.belongs_to :balance
      t.string :amount
      t.string :status, default: "Pending"
      t.string :type, default: "PayPal"
      t.string :withdraw_type
      t.timestamps
    end
  end
end

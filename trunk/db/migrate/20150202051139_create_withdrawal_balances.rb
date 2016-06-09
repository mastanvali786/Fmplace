class CreateWithdrawalBalances < ActiveRecord::Migration
  def change
    create_table :withdrawal_balances do |t|
    	t.belongs_to :withdrawal
      t.string :balance
      t.timestamps
    end
  end
end

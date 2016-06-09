class CreatePaymentBalances < ActiveRecord::Migration
  def change
    create_table :payment_balances do |t|
      t.belongs_to :payment
      t.string :balance
      t.timestamps
    end
  end
end

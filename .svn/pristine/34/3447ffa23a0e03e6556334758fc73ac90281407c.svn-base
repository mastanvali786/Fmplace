class CreateWithdrawalInvoices < ActiveRecord::Migration
  def change
    create_table :withdrawal_invoices do |t|
    	t.belongs_to :withdrawal_request
      t.integer :sender_id
      t.integer :receiver_id
      t.string :transaction_id
      t.date :paid_on
      t.text :data
      t.string :type
      t.string :amount
      t.timestamps
    end
  end
end

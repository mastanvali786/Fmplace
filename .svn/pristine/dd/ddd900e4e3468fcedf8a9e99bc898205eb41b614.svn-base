class CreateDepositInvoices < ActiveRecord::Migration
  def change
    create_table :deposit_invoices do |t|
      t.belongs_to :deposit_request
      t.integer :sender_id
      t.integer :receiver_id
      t.string :transaction_id
      t.datetime :paid_on
      t.text :data
      t.string :type
      t.string :amount
      t.timestamps
      t.timestamps
    end
  end
end

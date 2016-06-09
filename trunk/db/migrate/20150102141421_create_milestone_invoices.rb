class CreateMilestoneInvoices < ActiveRecord::Migration
  def change
    create_table :milestone_invoices do |t|
      t.belongs_to :milestone_funding_request
      t.integer :receiver_id
      t.integer :sender_id
      t.boolean :funded, default: false
      t.date :paidOn
      t.text :data
      t.string :type
      t.string :amount
      t.string :transaction_id
      t.timestamps
    end
  end
end

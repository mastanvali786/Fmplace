class CreatePendingPayments < ActiveRecord::Migration
  def change
    create_table :pending_payments do |t|
    	t.string :handler
    	t.string :pay_key
    	t.integer :handler_id
    	t.boolean :processed, default:false
    	t.text :data
    	t.string :type
      t.timestamps
    end
  end
end

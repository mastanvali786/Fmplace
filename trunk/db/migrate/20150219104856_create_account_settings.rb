class CreateAccountSettings < ActiveRecord::Migration
  def change
    create_table :account_settings do |t|
    	t.string  :paypal_email
    	t.integer :withdraw, default: 0
    	t.integer :user_id
    	t.integer :account_number
      t.timestamps
    end
  end
end

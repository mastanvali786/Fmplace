class AddFieldsToAccountSetting < ActiveRecord::Migration
  def change
  	add_column :account_settings, :payment_type_id, :integer
  	add_column :account_settings, :payfast_email, :string
  	add_column :account_settings, :merchant_id, :integer
  	add_column :account_settings, :merchant_key, :string
  end
end

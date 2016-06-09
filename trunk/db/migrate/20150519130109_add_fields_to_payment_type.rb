class AddFieldsToPaymentType < ActiveRecord::Migration
  def change
    add_column :payment_types, :display_name, :string
    add_column :payment_types, :active, :boolean, default: true
  end
end

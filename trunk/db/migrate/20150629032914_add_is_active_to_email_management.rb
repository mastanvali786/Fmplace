class AddIsActiveToEmailManagement < ActiveRecord::Migration
  def change
    add_column :email_managements, :is_active,:boolean, default: false
  end
end

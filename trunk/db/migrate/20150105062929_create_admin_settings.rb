class CreateAdminSettings < ActiveRecord::Migration
  def change
    create_table :admin_settings do |t|
    	t.string :first_name
    	t.string :last_name
    	t.string :email
    	t.boolean :loading, default: true
    	t.integer :bid_fee, default: 5
      t.timestamps
    end
    AdminSetting.create(first_name: 'Site', last_name: 'Admin', email: 'admin@example.com')
  end
end

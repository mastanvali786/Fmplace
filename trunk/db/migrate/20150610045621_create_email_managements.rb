class CreateEmailManagements < ActiveRecord::Migration
  def change
    create_table :email_managements do |t|
    	t.string :options
      t.string :api_user
      t.string :api_key
      t.timestamps null: false
    end
  end
end

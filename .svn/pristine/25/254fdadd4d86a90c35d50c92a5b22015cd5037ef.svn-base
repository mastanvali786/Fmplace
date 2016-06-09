class CreateUserBiographies < ActiveRecord::Migration
  def change
    create_table :user_biographies do |t|
      t.integer	:user_id
      t.text	:summary
      t.timestamps
    end

    add_index :user_biographies, :user_id
  end
end

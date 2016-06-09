class AddBaseIdToUser < ActiveRecord::Migration
  def change
  	add_column :users, :user_id, :integer, default: 0
  end
end

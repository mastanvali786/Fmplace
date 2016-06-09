class AddFieldsToUser < ActiveRecord::Migration
  def change
  	add_column :users, :priority, :boolean, default: false
  end
end

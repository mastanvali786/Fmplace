class AddSearchPriorityToUser < ActiveRecord::Migration
  def change
  	add_column :users, :search_priority, :boolean, default: false
  end
end

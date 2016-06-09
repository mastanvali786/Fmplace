class CreateBudgetOptions < ActiveRecord::Migration
  def change
    create_table :budget_options do |t|
      t.string :name
      t.integer :project_budget_id
      t.timestamps
    end

    add_index :budget_options, :project_budget_id
  end
end

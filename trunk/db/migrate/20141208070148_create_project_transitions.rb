class CreateProjectTransitions < ActiveRecord::Migration
  def change
    create_table :project_transitions do |t|
      t.string :to_state
      t.text :metadata
      t.integer :sort_key
      t.integer :project_id
      t.timestamps
    end

    add_index :project_transitions, :project_id
    add_index :project_transitions, [:sort_key, :project_id], unique: true
  end
end

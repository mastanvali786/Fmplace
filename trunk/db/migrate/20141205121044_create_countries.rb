class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :name
      t.string :country_code
      t.integer :state_id
      t.integer :visible
      t.timestamps
    end
  end
end

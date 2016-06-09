
class CreateThemeSettings < ActiveRecord::Migration
  def change
    create_table :theme_settings do |t|
   	  t.integer :theme_id, default: 1
      t.timestamps
    end
  end
end

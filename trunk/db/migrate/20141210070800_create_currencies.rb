class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currencies do |t|
      t.string :currency_abbrev
      t.string :currency_name
      t.string :rate
      t.string :symbol

      t.timestamps
    end
  end
  
end

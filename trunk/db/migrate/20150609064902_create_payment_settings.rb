class CreatePaymentSettings < ActiveRecord::Migration
  def change
    create_table :payment_settings do |t|
      t.integer :payment_type_id
      t.string :key1
      t.string :value1
      t.string :key2
      t.string :value2
      t.string :key3
      t.string :value3
      t.string :key4
      t.string :value4
      t.string :key5
      t.string :value5
      t.string :key6
      t.string :value6
      t.string :key7
      t.string :value7
      t.string :key8
      t.string :value8
      t.string :key9
      t.boolean :value9
      t.timestamps
    end
  end
end

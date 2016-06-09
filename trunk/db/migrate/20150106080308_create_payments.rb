class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :to
      t.string :type
      t.string :klass, default: "Milestone"
      t.decimal :amount, precision:8, scale:2
      t.datetime :approvedOn
      t.boolean :approved, default: false
      t.integer :approvedBy
      t.boolean :declined, default: false
      t.timestamps
    end
  end
end

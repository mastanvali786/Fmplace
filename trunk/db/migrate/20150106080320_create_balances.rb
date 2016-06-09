class CreateBalances < ActiveRecord::Migration
  def change
    create_table :balances do |t|
      t.belongs_to :user
      t.decimal :amount, precision:8, scale:2, default:0
    end
  end
end

class CreatePaymentDetails < ActiveRecord::Migration
  def change
    create_table :payment_details do |t|
      t.belongs_to :payment
      t.text :data
    end
  end
end

class CreateBids < ActiveRecord::Migration
  def change
    create_table :bids do |t|
      t.references :project
      t.references :user
      t.text :details
      t.boolean :accepted, default: false
      t.boolean :withdrawn, default: false
      t.boolean :featured, default: false
      t.integer :estimated_days
      t.float :proposed_amount
      t.float :earned_amount
      t.boolean :awarded, default: false
      t.boolean :declined, default: false
      t.boolean :hidden, default: false
      t.boolean :violation, default: false
      t.date :awarded_date
      t.date :accepted_date
      t.date :declined_date
      t.integer :payment_id
      t.text :buyer_note
      t.timestamps
    end
  end
end

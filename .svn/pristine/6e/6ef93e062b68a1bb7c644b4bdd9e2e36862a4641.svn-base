class AddReferralAmountToUser < ActiveRecord::Migration
  def change
    add_column :users, :referral_amount, :decimal,  default: 0
    add_column :users, :referral_source, :string
  end
end

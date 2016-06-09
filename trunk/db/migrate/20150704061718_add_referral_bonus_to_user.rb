class AddReferralBonusToUser < ActiveRecord::Migration
  def change
  	add_column :users, :referral_bonus, :boolean, default: false
  end
end

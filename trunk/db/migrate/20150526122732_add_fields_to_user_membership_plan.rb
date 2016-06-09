class AddFieldsToUserMembershipPlan < ActiveRecord::Migration
  def change
  	add_column :user_membership_plans, :payment_method, :boolean, default: 1
  end
end

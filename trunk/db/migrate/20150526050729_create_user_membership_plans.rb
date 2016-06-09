class CreateUserMembershipPlans < ActiveRecord::Migration
  def change
    create_table :user_membership_plans do |t|
      t.integer :user_id
      t.integer :membership_plan_id
      t.datetime :start_date
      t.datetime :expire_date
      t.timestamps
    end
  end
end

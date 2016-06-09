class CreateMembershipPlans < ActiveRecord::Migration
  def change
    create_table :membership_plans do |t|
    	t.string :name
		t.decimal :amount
		t.integer :highlight_skills
		t.boolean :showcase_portfolio, default: false
		t.boolean :higher_search, default: false
		t.string :team_count
		t.string :connects
		t.boolean :more_connects, default: false
		t.boolean :more_category, default: false
		t.boolean :pricing_view, default: false
		t.boolean :feature_samples, default: false
		t.boolean :escrow_protection, default: false
		t.boolean :wire_transfer, default: false
		t.decimal :service_fee
      t.timestamps
    end
  end
end


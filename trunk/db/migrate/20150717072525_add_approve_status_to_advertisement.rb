class AddApproveStatusToAdvertisement < ActiveRecord::Migration
  def change
    add_column :advertisements, :admin_approved, :boolean, default: false
  end
end

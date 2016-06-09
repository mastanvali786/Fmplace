class AddFieldsToAdvertisement < ActiveRecord::Migration
  def change
    add_column :advertisements, :status, :boolean, default: true
    add_column :advertisements, :no_of_clicks, :integer, default: 0
    add_column :advertisements, :no_of_views, :integer, default: 0
  end
end

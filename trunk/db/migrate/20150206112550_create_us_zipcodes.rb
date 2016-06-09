class CreateUsZipcodes < ActiveRecord::Migration
  def change
    create_table :us_zipcodes do |t|
    	t.string :ZIPCode
    	t.string :ZIPCodeType
    	t.string :City
    	t.string :CityType
    	t.string :State
    	t.string :StateCode
    	t.string :AreaCode
    	t.integer :Latitude, default: 0
    	t.integer :Longitude, default: 0
    	t.string :timezone
    	t.string :dst
      t.timestamps
    end
  end
end
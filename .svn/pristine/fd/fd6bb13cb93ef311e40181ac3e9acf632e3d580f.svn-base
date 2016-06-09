class CreateAdsClickInfos < ActiveRecord::Migration
  def change
    create_table :ads_click_infos do |t|
      t.references :advertisement, index: true
      t.string :ip
      t.string :country_code
      t.string :country_name
      t.string :region_code
      t.string :region_name
      t.string :city
      t.string :zip_code
      t.string :time_zone
      t.string :latitude
      t.string :longitude
      t.datetime :click_date
      t.timestamps
    end
  end
end
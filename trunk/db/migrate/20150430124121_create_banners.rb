class CreateBanners < ActiveRecord::Migration
  def change
    create_table :banners do |t|
      t.string :slider_image

      t.timestamps
    end
  end
end

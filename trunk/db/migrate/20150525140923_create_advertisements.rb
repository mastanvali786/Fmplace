class CreateAdvertisements < ActiveRecord::Migration
  def change
    create_table :advertisements do |t|
    	 t.string   :campaign_name
    	 t.string   :ad_title
    	 t.text   :ad_content
    	 t.string   :ad_url
    	 t.string   :banner_photo
    	 t.boolean  :show_continuously, default: true
    	 t.datetime :stop_date
    	 t.text     :days_week
    	 t.text     :ad_sections_ids
    	 t.string   :keywords
    	 t.float    :budget_per_click
    	 t.float    :budget_per_day
    	 t.integer  :user_id
      t.timestamps
    end
  end
end

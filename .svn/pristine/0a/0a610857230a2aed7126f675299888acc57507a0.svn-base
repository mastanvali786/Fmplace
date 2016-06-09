class Advertisement < ActiveRecord::Base
	validates_presence_of :campaign_name,:ad_url,:budget_per_click, :budget_per_day, :user_id
	mount_uploader :banner_photo, AvatarUploader
	has_many :ads_click_infos
	belongs_to :user
	belongs_to :ad_section
	scope :active_ads, ->  { where(status: true) }
	scope :admin_approved_ads, -> { where(admin_approved: true)}
	has_one :balance, through: :user

	def self.get_ads_to_show(page)
		@advertisements = Advertisement.joins(:user).joins(:balance).where("amount > ?", "user.advertisement.budget_per_day").admin_approved_ads.active_ads.where('stop_date >= ? OR stop_date IS NULL', DateTime.now).order('updated_at DESC')
		if @advertisements.present?
			@selctional_ads = @advertisements.select{|z| z.ad_sections_ids.split(",").include?(page)}
			@all_selctional_ads = @advertisements.select{|z| z.ad_sections_ids.empty? }
			@combined_ads = @all_selctional_ads.concat(@selctional_ads)
			if @combined_ads.present?
				@wday_advertisements = @combined_ads.select{|z| z.days_week.split(",").map(&:to_i).include?(DateTime.now.wday)}
				@all_day_advertisements = @combined_ads.select{|z| z.days_week.empty? }
				if @wday_advertisements.present?
					@all_advertisements = @all_day_advertisements.concat(@wday_advertisements)
					@advertisements = @all_advertisements.select{|x| x.paid_click? }
				else
					@advertisements = @all_day_advertisements.select{|x| x.paid_click? }
				end
			else
				return false
			end
		end
		update_impression_count(@advertisements)
		return @advertisements
	end

	def show_week_day?(id)
		if days_week
			result =  days_week.split(',').include?(id.to_s)
		end
		"checked" if result
	end

	def show_section(id)
		if ad_sections_ids
			result = ad_sections_ids.split(',').include?(id.to_s)
		end
		"checked" if result
	end

	def paid_click_per_day
		clicks = 0
		clicks = budget_per_day / budget_per_click
		clicks.to_i
	end

	def paid_click?
		today_count = ads_click_infos.where("created_at >= ?", Time.zone.now.beginning_of_day).count
		today_count < paid_click_per_day ? true : false
	end

	def ad_status
		status ? "Active" : "Pause"
	end

	protected

	def self.update_impression_count(ads)
		ads.each do |ad|
			ad.increment!(:no_of_views) 
		end
	end

end
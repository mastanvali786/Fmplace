module ApplicationHelper
require 'sendgrid-ruby'
	def is_paypal_active?
		PaymentType.find_by_name("PAYPAL").active?
	end

	def payment_method(user)
	 user.account_setting.payment_type_name if (user.account_setting.present? && user.account_setting.payment_type_id.present?)
	end

	def date_long(date)
		date.strftime("%e %b %Y, %I:%M %p") if date
	end
def email_setting(user,subject,body,sendemail)
		email= EmailManagement.find_by_is_active(1)
		emailcount= EmailManagement.where(:is_active=>1).count
		if emailcount<1
			ActionMailer::Base.smtp_settings = {
				:enable_starttls_auto => true,
				:address => "smtp.gmail.com",
				:port => 587,
				:domain => "gmail.com",
				:authentication => 'plain',
				:user_name => 'auctionsoftwares@gmail.com',
				:password => 'auction!@#'
			}


			ActionMailer::Base.delay.mail(:content_type => 'text/html',from: MAILER_FROM,to: sendemail, subject: subject, body: body)

		else

		emailtype=email.options
		emailuser=email.api_user
		emailpass=email.api_key
		if emailtype == 'local mail'
			ActionMailer::Base.smtp_settings = {
				:enable_starttls_auto => true,
				:address => "smtp.gmail.com",
				:port => 587,
				:domain => "gmail.com",
				:authentication => 'plain',
				:user_name => emailuser,
				:password => emailpass
			}


			ActionMailer::Base.delay.mail(:content_type => 'text/html',from: MAILER_FROM,to: sendemail, subject: subject, body: body)

		elsif emailtype == 'send grid'

			client = SendGrid::Client.new(api_user: emailuser, api_key: emailpass)

			sendsengridemail = SendGrid::Mail.new do |m|
				m.to      = sendemail
				m.from    = MAILER_FROM
				m.subject = subject
				m.html    = body
			end

			client.send(sendsengridemail)
		elsif emailtype=='Customer.io'
			$customerio = Customerio::Client.new(emailuser, emailpass)
			# $customerio.identify(
			# 	id: user.id,
			# 	email: user.email,
			# 	first_name: user.first_name,

			# 	)
			$customerio.track(5, "reverse", :subject => subject, :body => body,:email =>sendemail)
		end
end
	end

	# def email_setting
	# 	email=EmailManagement.first
	# 	emailtype=email.options
	# 	emailuser=email.api_user
	# 	emailpass=email.api_key
	# 	if emailtype == 'local mail'
	# 		ActionMailer::Base.smtp_settings = {
	# 			:enable_starttls_auto => true,
	# 			:address => "smtp.gmail.com",
	# 			:port => 587,
	# 			:domain => "gmail.com",
	# 			:authentication => 'plain',
	# 			:user_name => emailuser,
	# 			:password => emailpass
	# 		}
	# 	elsif emailtype == 'send grid'
	# 		ActionMailer::Base.smtp_settings = {
	# 			:user_name => emailuser,
	# 			:password => emailpass,
	# 			:address => 'smtp.sendgrid.net',
	# 			:port => 587,
	# 			:authentication => :plain,
	# 			:enable_starttls_auto => true
	# 		}

	# 	end

	# end


	# def sendcustomerio(user,subject,body)
	# 	email=EmailManagement.first
	# 	emailuser=email.api_user
	# 	emailpass=email.api_key
	# 	$customerio = Customerio::Client.new(emailuser, emailpass)
	# 	$customerio.identify(
	# 		id: user.id,
	# 		email: user.email,
	# 		first_name: user.first_name,

	# 		)
	# 	$customerio.track(user.id, "reverse", :subject => subject, :body => body)


	# end
def user_new_time_zone(user, date_time)
    if date_time
      date_time.in_time_zone(user.try(:time_zone)).strftime("%e %b %Y, %I:%M %p")
    end
  end
	def user_time_zone(date_time)
		if date_time
		  date_time.in_time_zone(current_user.try(:time_zone)).strftime("%e %b %Y, %I:%M %p")
	  end
	end

	def user_date_zone(date)
		if date
		   date.in_time_zone(current_user.try(:time_zone)).strftime("%e %b %Y")
	    end
	end

	def date_time(datetime)
		if datetime
		  datetime.strftime("%e %b %Y, %I:%M %p")
	  end
	end

	def url_base
		"http://dev.archability.com/arch"
	end

	def yes_no(true_false)
		true_false ? "Yes" : "No"
	end

	def mos_day_year(date)
		date.strftime  "%m/%d/%Y"
	end

	def get_name_by_ids(model=nil, ids=[])
		if ids
			ids.map! { |x| x.to_i }
			model.select { |c| ids.include?(c.id) }.map(&:name).split(',').join(', ') if model
	  end
	end

	def day_month_year(date)
		date.strftime  "%d %b,  %Y"
	end

	def month_day_year(date)
		date.strftime  "%b %d,  %Y"
	end

	def month_day(date)
		date.strftime('%B %d')
	end

	def us_country_id
		country = Country.find_by_country_code('US') || Country.find_by_country_code('USA')
		country.id if country
	end

	def feature_proposal_price
		FEATURE_PRICE || 10
	end

	def admin_email
		AdminSetting.first.try(:email) || 'auctionsoftwares@gmail.com'
	end

	def admin_name
		"#{AdminSetting.first.try(:first_name)} #{AdminSetting.first.try(:last_name)}" || 'Site Admin'
	end

	def to_currency amount
    number_to_currency amount
  end

		def profile_complete
		maximumPoints = 100;
		point = 40

		if current_user.role_id.eql?(2)

			if  current_user.state_id.present?
				point+=10
			end
			if current_user.city.present?
				point+=5
			end
			if current_user.address.present?
				point+=5
			end
			if current_user.zipcode.present?
				point+=5
			end
			if current_user.profile_photo.present?
				point+=10
			end
			if current_user.video_url.present?
				point+=5
			end
			if current_user.country_id.present?
				point+=10
			end
			if current_user.time_zone.present?
				point+=10
			end
		else
			if current_user.profile_photo.present?
				point+=10
			end
			if current_user.video_url.present?
				point+=5
			end
			if current_user.user_skill.present?
				point+=5
			end
			if current_user.user_biography.present?
				point+=5
			end
			if current_user.user_experiences.present?
				point+=5
			end
			if current_user.domain_expertise.present?
				point+=5
			end
			if current_user.user_educations.present?
				point+=5
			end
			if current_user.category_ids.present?
				point+=5
			end
			if current_user.country_id.present? && current_user.state_id.present?
				point+=10
			end
			if current_user.city.present? && current_user.zipcode.present?
				point+=5
			end
		end

		percentage = (point*maximumPoints)/100
		return percentage
	end


	def get_logo
	 	@theme = ThemeSetting.first
	 	@theme.logo
	end


	def my_membership?(user)
		if user.membership_plan_name == MembershipPlan.first.name
			return false
		else
			return true
		end
	end


	def get_membership_plan(user)
		if user.membership_plan_name == MembershipPlan.first.name
			return true
		else
			return false
		end
	end

	def curren_plan(user)
		user.membership_plan_name
	end


	def get_service_fee(user)
		if user.seller?
			if user.membership_plan.present?
				user.membership_plan.service_fee
			else
				AdminSetting.first.try(:bid_fee) || 5
			end
		else
			AdminSetting.first.try(:bid_fee) || 5
		end
	end
end

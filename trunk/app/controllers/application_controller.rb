class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format.include? 'application/json' }
  include ApplicationHelper
  helper :authorize_net
  after_filter :store_online_users
  #before_filter :get_advertisement
  before_filter :get_token_for_braintree
  #before_filter :session_location
  after_filter :set_csrf_cookie

  def set_csrf_cookie
    if protect_against_forgery?
      response.headers['X-CSRF-Param'] = "#{request_forgery_protection_token}"
      response.headers['X-CSRF-Token'] = "#{form_authenticity_token}"
    end
  end

  def get_token_for_braintree
    Braintree::Configuration.environment = :sandbox
    Braintree::Configuration.logger = Logger.new('log/braintree.log')
    Braintree::Configuration.merchant_id = PaymentType.braintree_merchant_id
    Braintree::Configuration.public_key = PaymentType.braintree_public_key
    Braintree::Configuration.private_key = PaymentType.braintree_private_key
    if current_user && payment_method(current_user) == 'BRAINTREE'
      gon.client_token = generate_client_token
    end
  end

  def session_location
    session[:ip] ||= request.location.ip
    session[:country_code] ||= request.location.country_code
    session[:country_name] ||= request.location.country_name
    session[:region_code] ||= request.location.region_code
    session[:region_name] ||= request.location.region_name
    session[:city] ||= request.location.city
    session[:zip_code] ||= request.location.zip_code
    session[:time_zone] ||= request.location.time_zone
    session[:latitude] ||= request.location.latitude
    session[:longitude] ||= request.location.longitude
  end

  def get_advertisement
    offset = rand(Advertisement.count)
    rand_record = Advertisement.offset(offset).first
    session[:advertisements] = rand_record
  end

  def store_online_users
    session[:online_session_id] ||= request.session.id
    session_id = session[:online_session_id]
    if session_id.present?
      get_session_data
      unless exists_session?(session_id)
        if current_user
          user = OnlineUser.create(session_id: @session_id, ip_address: @ip, url: @url,
           browser_name: @browser, browser_version: @br_version.try(:to_s), platform: @os,
           user_id: current_user.id, user_type: "USER")
        else
          user = OnlineUser.create(session_id: @session_id, ip_address: @ip, url: @url,
           browser_name: @browser, browser_version: @br_version.try(:to_s), platform: @os)
        end
      else
        user = OnlineUser.find_by_session_id(@session_id)
        user.update_attributes(url: @url) if @url.length <= 250
      end
    end
  end

  def get_session_data
    @session_id = session[:online_session_id]
    @user_agent = UserAgent.parse(request.env['HTTP_USER_AGENT'])    
    @browser = @user_agent.browser
    @br_version = @user_agent.version
    @os = @user_agent.platform
    @ip = request.remote_ip
    @url = request.original_url
  end

  def exists_session?(session_id)
    return true if OnlineUser.find_by_session_id(session_id)
    false
  end

  def after_sign_in_path_for(resource_or_scope)
    do_session_management(resource_or_scope)
    if resource_or_scope.try(:role_id)
      projects_path
    else
      admin_root_path
    end
  end

  def delete_duplicate_session
    get_session_data
    dup_users = OnlineUser.where(session_id: @session_id)
    dup_users.destroy_all
  end

  def do_session_management(resource)
    get_session_data
    user = OnlineUser.find_by_session_id(@session_id)
    if resource.try(:role_id)
      user.update_attributes(user_type: 'USER',user_id: resource.id) if user
    else
      user.update_attributes(user_type: 'ADMIN',user_id: resource.id) if user
    end
  end

  def send_after_project_create(project)
    cat_id = project.category_id
    if cat_id
      @vetted_sellers = User.approved_shops.where(notify_category: true)
      @vetted_sellers.each do |user|
        if user.category_ids.include?(cat_id.to_s)
          emailtemplate=EmailTemplate.find_by_template('a_client_is_requesting_a_quote')
          subject=emailtemplate.subject
          body=emailtemplate.content % {user_visible_name: user.visible_name, full_title: project.full_title, category_name: project.category_name,subcategory_name: project.subcategory_name,tags: project.tags,skills: project.skills,budget: project.budget,estimated_time: project.estimated_time,location: project.location,description: project.description,site_logo:SITE_LOGO,login_url:SITE_LOGIN_URL,site_email:EMAIL_SIGN_EMAIL,site_phone:EMAIL_SIGN_NUMBER}
          email_setting(user,subject,body,user.email)
    #ProjectMailer.delay.project_notification(user,project)
  end
end
end
end

def post_project_attachment(params)
  if params[:project]['file_name']
    params[:project]['file_name'].each do |file|
      attachment = @project.attachments.create(file_name: file,
        user_id: params[:project][:user_id], attach_type: 'Project')
    end
  end
end

def get_logo
  @theme = ThemeSetting.first
  if @theme.logo.present?
    "#{Rails.root}"+ "/public" + @theme.logo.thumb.to_s
  else
    "#{Rails.root}/app/assets/images/logo.png"
  end
end

def braintree_deposit(params)
  amount = params[:amount]
  set_current_user
  balance = current_user.balance
  error_message = ""
  error = false
  amount = params[:amount].to_f
  request = balance.braintree_request_deposit amount
  invoice = request.invoice
      #payment_settings = authorize_credit_url(request)
      unless invoice.present?
        error = true
        error_message = "The system encountered an error.  Please contact appropriate persons."
      end
      return invoice, error
    end

    def set_back_url
      @back = back_url
    end

    def back_url
      request.headers["Referer"]
    end

    def set_current_user
      User.current = current_user
    end

    def current_user_set_paypal_ipn_settings(url=back_url)
      current_user.ipn_settings = OpenStruct.new({ current_url:url, paypal_ipn_url:ipn_paypal_url})
    end

    def isint(str)
      return !!(str =~ /^[-+]?[1-9]([0-9]*)?$/)
    end

    private

    def generate_client_token
      if current_user.has_payment_info?
        Braintree::ClientToken.generate(customer_id: current_user.braintree_customer_id)
      else
        Braintree::ClientToken.generate
      end
    end

  end

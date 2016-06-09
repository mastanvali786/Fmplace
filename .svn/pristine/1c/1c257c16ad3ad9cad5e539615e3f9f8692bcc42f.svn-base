class SessionsController < Devise::SessionsController
 after_filter :handle_failed_login, :only => :new

  def new
    @user_email = cookies[:user_email]
    @check_value = cookies[:user_email].present?
    super
  end

  def create
    if params[:platform] == "mobileApp"
      mobile_login
    else
    	@resource = warden.authenticate!(scope: resource_name, recall: "#{controller_path}#failure")
      if params[:user][:remember_me] == '1'
        cookies.permanent[:user_email] = @resource.email
      else
        cookies.permanent[:user_email] = nil
      end
      sign_in(resource_name, @resource)
      flash[:notice] = 'Signed in successfully.'
      redirect_to after_sign_in_path_for(@resource)
    end
  end

  def mobile_login
    user = User.find_by_email(params[:user][:email])
    if user && user.valid_password?(params[:user][:password])
      if user.confirmed_at? &&  user.is_active.eql?(true)
         render json: {result: true, user_id: user.id, role_id: user.role_id, msg: "Signed in successfully." }
      elsif user.is_active.eql?(false)
        render json: {result: false, msg: "Sorry, this account has been deactivated. Please contact Admin at #{admin_email}" }
      else
        render json: {result: false, msg: "Please Confirm your email address in the confirmation email sent to activate your account" }
      end
    else
      render json: {result: false, msg: "Invalid email or password." }
    end
  end

  def failure
  	flash[:error] = "Login information is incorrect, please try again."
    if params[:platform] == "mobileApp"
      render json: {result: false}
    else
      redirect_to root_url
    end
  end

  def destroy_mobile_login
    @user = User.find_by_id(params[:user_id])
    if @user
      sign_out @user
      render json: {result: true, msg: "" }
    else
      render json: {result: false, msg: "" }
    end
  end

  def destroy
    delete_duplicate_session
     if params[:platform] == "mobileApp"
      destroy_mobile_login
    else
  	  super
    end
  end

  private
  def handle_failed_login
    if failed_login?
      render json: { result: false, errors: ["Login Credentials Failed"] }, status: 401
    end
  end 

  def failed_login?
    (options = env["warden.options"]) && options[:action] == "unauthenticated"
  end 

end

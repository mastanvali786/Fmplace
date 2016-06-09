
class OmniauthCallbacksController < Devise::OmniauthCallbacksController
   def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    auth = request.env["omniauth.auth"]
    @user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.from_omniauth(auth,request.env['omniauth.params'])
   if @user.persisted?
      if @user.role_id.nil?
          sign_in(@user, :bypass => true)
         redirect_to select_role_path
      else
        sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
        set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
      end
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

   def linkedin
    auth = request.env["omniauth.auth"]
     @user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.from_omniauth(request.env["omniauth.auth"],request.env['omniauth.params'])
     if @user.persisted?
      if @user.role_id.nil?
          sign_in(@user, :bypass => true)
         redirect_to select_role_path
      else
        sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
        set_flash_message(:notice, :success, :kind => "Linkedin") if is_navigational_format?
      end
    else
      session["devise.linkedin_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
  
end

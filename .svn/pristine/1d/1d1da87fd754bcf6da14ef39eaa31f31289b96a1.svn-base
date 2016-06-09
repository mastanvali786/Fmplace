class HomesController < ApplicationController
	
	def index
    @testimonials = Testimonial.all
    @banners = Banner.all
  end

  def contact
    unless params[:contact_email].blank?
      contacts = ContactEmail.new(contact_params)
      if contacts.save
      
      emailtemplate=EmailTemplate.find_by_template('contact_us')
    
    body=emailtemplate.content % {name: contacts.name, email: contacts.email, subject:contacts.subject,message: contacts.message,site_logo:SITE_LOGO,site_email:EMAIL_SIGN_EMAIL,site_phone:EMAIL_SIGN_NUMBER}
    subject=emailtemplate.subject
    if contacts.email_copy
     @recepients=[contacts.email, MAILER_FROM]
    else
     @recepients= MAILER_FROM
    end
    email_setting(contacts,subject,body,@recepients)
        #UserMailer.delay.contact_email(contacts)
        flash[:notice] = "Thank you for contacting us.We'll get back to you soon."

      else
        flash[:error] = "Please Try After Some Time."
        redirect_to contact_path
      end
    end
  end

  def blog
  end

  def terms
    @terms = Terms.find 1
  end

  def news
  end

  def faq
    @faqs=Faq.all
  end

  def about_us
  end

  def how_it_works
  end

  def privacy
    @privacy = Privacy.find 1
  end

  def auction
    
  end

  def freelancers
  end

  def engines
   f = EngineModel.where(:subcategory_id=>params[:val])
   render :json=>f;
 end

 def learning_faq
 end

 def demo_logins
  session[:auto_value] = '0'
  sign_out(current_user) if current_user
  if params[:value] == '1'
    session[:auto_value] = '1'
    login_buyer_seller('developscriptbuyer@gmail.com','laxman@auctionsoftware.com')
  elsif params[:value] == '2'
    session[:auto_value] = '2'
    login_buyer_seller('developscriptseller@gmail.com','laxman@ilancecustomization.com')
  elsif params[:value] == '3'
    session[:auto_value] = '3'
    login_admin_user
  else
    redirect_to projects_path
  end
 end

 def login_buyer_seller(email1, email2)
   user = User.find_by_email(email1) || User.find_by_email(email2)
   sign_in(user, bypass: true) if user
   render js: "window.location.pathname='#{projects_path}'"
 end

 def login_admin_user
    user = AdminUser.first
    sign_in(user, bypass: true)
    render js: "window.location.pathname='#{admin_dashboard_path}'"
 end

 def engine_lookup
   @category=Category.find_by_name('Piston Aircraft Engine Lookup')
   @sub=@category.subcategories.limit(7)
   @engines=EngineModel.where(:subcategory_id=>@sub.first.id)
   @name=@sub.first.name  
 end
 def contact_params
  params.require(:contact_email).permit(:email,:subject, :name,:message,:email_copy)
end
end

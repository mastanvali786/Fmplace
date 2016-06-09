class MessagesController < ApplicationController
  before_filter :set_current_user

  def show
    @message = Message.find params[:id]
    unless session[:admin_login] == true
      @message.update_attribute(:read, true) if @message.read.eql?(false)
    end
    @conversations = @message.conversations.page(params[:page]).per(2)
  end

  def index
    folder = params[:folder]
    valid_folders = %w(inbox sent saved proposals invites)
    folder = "inbox" unless valid_folders.include?(folder)
    @folder = folder
    messages = current_user.messages
    @counts = valid_folders.inject({}) do |result, folder|
      type = folder
      type = "proposals_projects" if folder == "proposals"
      message = messages.send type
      result[folder] = message.count
      result
    end
    @messages = messages.send folder
    if params[:sort_by] == 'asc'
      @messages=@messages.order('created_at ASC')
    else
      @messages=@messages.order('created_at DESC')
    end
    @messages=@messages.page(params[:page]).per(5)
  end

  def create
    @message = Message.new message_params
    valid = true
    if (@to = params[:to]).present?
      receiver = User.where( email: @to ).first
      valid = receiver.present?
    end
    unless valid
      @message.errors[:to]= "- no user exists with this email address"
    else
      if @message.valid?
        @message.to = receiver.id
      end
      saved = @message.save
      if saved
        OverhaulMailer.delay.send_inbox_message(@message, current_user, receiver)
        @notice = "message was sent successfully."
      end
    end
    render_popup
  end

  def send_praposal_message
    @message = Message.new message_params
    valid = true
    if (@to = params[:to]).present?
      receiver = User.where( email: @to ).first
      valid = receiver.present?
    end
    unless valid
      flash[:error] = "No user exists with this email address"
    else
      if @message.valid?
        @message.to = receiver.id
      end
      saved = @message.save
      if saved
        notify_emails = []
        emailtemplate=EmailTemplate.find_by_template('send_inbox_message')

    body=emailtemplate.content % {login_url: SITE_LOGIN_URL, sender_visible_name: current_user.visible_name,receiver_visible_name: receiver.visible_name, message: @message.body,site_logo:SITE_LOGO,site_email:EMAIL_SIGN_EMAIL,site_phone:EMAIL_SIGN_NUMBER}
    subject=emailtemplate.subject % {visible_name: current_user.visible_name}
    if receiver.seller?
      notify_emails = receiver.notify_emails.split(',') if receiver.notify_emails
      notify_emails.push(receiver.email)
      notify_emails.each do |seller_email|
        email_setting(current_user,subject,body,current_user.email)
      end
    else
       email_setting(current_user,subject,body,receiver.email)
    end
    

    #OverhaulMailer.delay.send_inbox_message(@message, current_user, receiver)
          emailtemplate=EmailTemplate.find_by_template('sender_sent_a_message')

    body=emailtemplate.content % {admin_name: admin_name, sender_visible_name: current_user.visible_name,receiver_visible_name: receiver.visible_name, body: @message.body,site_logo:SITE_LOGO,site_email:EMAIL_SIGN_EMAIL,site_phone:EMAIL_SIGN_NUMBER}
    subject= emailtemplate.subject % {visible_name: current_user.visible_name}
    email_setting(current_user,subject,body,admin_email)
    #OverhaulMailer.delay.notify_admin_send_inbox_message(@message, current_user, receiver)
    flash[:notice] = "Message sent successfully."
  else
    flash[:error] = "Failed to sent message. Please try Again."
  end
end
redirect_to :back
end

def do_coversation
  errors =true
  ActiveRecord::Base.transaction do
    @send_conv = Conversation.new(conversation_params)
    if @send_conv.save
      @rec_conv = Conversation.create(conversation_params)
      @rec_conv.update_attribute(:message_id,@send_conv.message.other_message_id)
    else
      errors = false
    end
  end
  if errors
    @send_conv.message.update_attributes(read: false,folder: 'sent')
    @rec_conv.message.update_attributes(read: false,folder: 'inbox')
notify_emails = []
        emailtemplate=EmailTemplate.find_by_template('send_inbox_message')

    body=emailtemplate.content % {login_url: SITE_LOGIN_URL, sender_visible_name: @rec_conv.sender.visible_name,receiver_visible_name: @rec_conv.receiver.visible_name, message: @rec_conv.body,site_logo:SITE_LOGO,site_email:EMAIL_SIGN_EMAIL,site_phone:EMAIL_SIGN_NUMBER}
    subject=emailtemplate.subject % {visible_name: @rec_conv.sender.visible_name}
    if @rec_conv.receiver.seller?
      notify_emails = @rec_conv.receiver.notify_emails.split(',') if @rec_conv.receiver.notify_emails
      notify_emails.push(@rec_conv.receiver.email)
      notify_emails.each do |seller_email|
        email_setting(current_user,subject,body,@rec_conv.sender.email)
      end
    else
       email_setting(current_user,subject,body,@rec_conv.receiver.email)
    end
    

    #OverhaulMailer.delay.send_inbox_message(@rec_conv, @rec_conv.sender, @rec_conv.receiver)
         emailtemplate=EmailTemplate.find_by_template('sender_sent_a_message')

    body=emailtemplate.content % {admin_name: admin_name, sender_visible_name: @rec_conv.sender.visible_name,receiver_visible_name: @rec_conv.receiver.visible_name, body: @rec_conv.body,site_logo:SITE_LOGO,site_email:EMAIL_SIGN_EMAIL,site_phone:EMAIL_SIGN_NUMBER}
   subject=emailtemplate.subject % {visible_name: @rec_conv.sender.visible_name}
    email_setting(current_user,subject,body,admin_email)
    #OverhaulMailer.delay.notify_admin_send_inbox_message(@rec_conv, @rec_conv.sender, @rec_conv.receiver)
    flash[:notice] = "Message sent successfully."
  else
    flash[:error] = "Failed to sent message. Please try Again."
  end
  redirect_to :back
end

def popup_new
  @message = Message.new
  render_popup
end

def mutiple_messages
 if params[:multiple_delete] && params[:multiple_delete] == 'true'
  messages = Message.where(:id=>params[:ids].split(','))
  messages.destroy_all if messages
  render :json=>{status:'success'}
elsif params[:multiple_save] && params[:multiple_save] == 'true'
 messages = Message.where(:id=>params[:ids].split(',')).update_all(:folder=> 'saved')
 render :json=>{status:'success'}
end
end
private
def permitted_params
  [:subject, :body, :type]
end

def message_params
  params[:to] = params[:message][:to]
  params[:message].delete :to
  params.require(:message).permit(permitted_params)
end

def conversation_params
  params.require(:conversation).permit!
end

def render_popup
  content = render_to_string "popup", layout: false
  js = {content:content}
  render json: js
end
end

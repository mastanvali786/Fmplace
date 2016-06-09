class ProjectMessagesController < ApplicationController

  before_filter :load_project

  before_filter :set_current_user

  def create
    @message = @project.messages.new message_params
    @message.subscribe(@project)
    saved = @message.save
    if saved
      flash[:notice] = "Message was created successfully."
    end
    redirect_to :back
  end

  def popup_new
    @message = @project.messages.new
    handle_popup
  end

  def filter

  end

  def save
    update_folder("saved")
  end

  def delete
    update_folder("deleted")
  end

  def update
    if @message.update_attributes message_params
      @notice = "message was updated successfully."
    end
    render_popup
  end

  private

  def update_folder(folder)
    messageIds = params[:messageIds]
    @project.messages.where(id: messageIds).update_all(folder:folder)
    json = {}
    json[folder] = messageIds
    respond_to do |format|
      format.json do
        render json: json
      end
    end
  end

  def permitted_params
    [:subject, :body, :type]
  end

  def message_params
    params.require(:message).permit(permitted_params)
  end

  def load_message
    @message = @project.messages.find(params[:id])
  end

  def load_project
    @project = Project.find params[:project_id]
  end

  def handle_popup
    @status = :ok
    render_popup
  end

  def render_popup
    content = render_to_string "popup", locals: {notice:@notice, message:@message, project:@project}, layout: false
    js = {content:content}
    status = :ok
    unless @message.valid?
      status = :unprocessable_entity
      js[:errors] = true
    end
    render json: js, status: @status || status
  end
end

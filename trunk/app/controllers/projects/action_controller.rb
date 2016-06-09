class Projects::ActionController < ApplicationController
  before_filter :authenticate_user!
  before_filter  :set_current_user
  before_filter  :load_project
  before_filter  :check_permission
  before_filter  :render_section, :except=>[:proposal,:complete_project]
  helper :authorize_net
  protect_from_forgery :except => :relay_response
  require "pdf/simpletable"

  def milestone
    @milestones = @project.milestones.order('updated_at DESC').page(params[:page]).per(PER_PAGE_COUNT)
    @milestone = Milestone.new
  end

  def milestone_pdf
    @milestones = @project.milestones
    respond_to do |format|
      format.pdf do
        logo = get_logo
        pdf = MilestonePdf.new(@project,@milestones, view_context, logo) 
        send_data pdf.render, :filename => 'products.pdf', :type => 'application/pdf', :disposition => 'inline'
      end
    end
  end

  def message
    @messages = @project.messages.order('updated_at DESC').page(params[:page]).per(PER_PAGE_COUNT)
  end

  def file
    @sort = params[:sort] || "created_at"
    @files = @project.files
    unless @sort == "uploaded_by"
      @files = @files.order("#{@sort} ASC")
    else
      @files = @files.joins(:user).order("concat(users.first_name, ' ', users.last_name) ASC")
    end
    @files = @files.page(params[:page]).per(PER_PAGE_COUNT)
    @base_path = request.original_url.split('?').first
    @base_path = @base_path + "?id=#{params[:id]}"
  end

  def upload
    file = @project.files.new params.require(:project).permit(:file)
    file.save!
    redirect_to :back
  end

  def proposal
    redirect_to project_path(@project.id)
  end

  def payment
    @milestones = @project.milestones.accepted.order('updated_at DESC').page(params[:page]).per(PER_PAGE_COUNT)
  end

  def mark
    @mark_milestones = @project.milestones.order('updated_at DESC').page(params[:page]).per(PER_PAGE_COUNT)
  end

  def feedback
  end

  def dispute
  end

  def complete_project
    if current_user.buyer?
      can_complete = false
      if @project.milestones.try(:pending).count > 0
        can_complete = false
      else
        milestones = @project.milestones.accepted
        milestones.each do |mile|
          can_complete = true if mile.paid?
        end
      end
      @project.transition_to!(:completed) if can_complete
      send_feedback_request_email(@project) if @project.completed?
    end
    render text: can_complete
  end

  def send_feedback_request_email(project)
    project = project
    project_url = "#{SITE_URL}/projects/action/feedback?id=#{project.id}"
       emailtemplate=EmailTemplate.find_by_template('rate_your_buyer')
    
    body=emailtemplate.content % {visible_name: project.buyer.visible_name, project_url: project_url,site_name: SITE_NAME,site_logo:SITE_LOGO,site_email:EMAIL_SIGN_EMAIL,site_phone:EMAIL_SIGN_NUMBER}
    subject=emailtemplate.subject % {label_short: DISPLAY_LABEL_SHORT}
    email_setting(current_user,subject,body,project.buyer.email)
    #OverhaulMailer.delay.request_for_review_buyer(project, project_url)
       emailtemplate=EmailTemplate.find_by_template('rate_your_seller')
    
     body=emailtemplate.content % {visible_name: project.seller.visible_name, project_url: project_url,site_name: SITE_NAME,site_logo:SITE_LOGO,site_email:EMAIL_SIGN_EMAIL,site_phone:EMAIL_SIGN_NUMBER}
   subject=subject=emailtemplate.subject % {name_short: BUYER_NAME_SHORT}
    email_setting(current_user,subject,body,project.seller.email)
    #OverhaulMailer.delay.request_for_review_seller(project, project_url)
  end

  protected

  def render_filter
    instance_eval do
      def default_render
        render :action
      end
    end
  end

  private
  def load_project
    @project = Project.find(params[:id])
  end
  def render_section
    @section = params[:action]
    render_filter
  end
  def check_permission
    p = @project
    unless current_user.id == p.user.id || current_user.id == p.project_seller.try(:user).id
      redirect_to projects_path
    end
  end
end
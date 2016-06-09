ActiveAdmin.register Feedback do

  menu :parent => "Other Settings"

  scope :pending, :default => true
  scope :approved

  actions  :index, :show, :destroy
  filter :user, label: "USER", :collection => proc {(User.all).map{|c| [c.first_name, c.id]}}
  filter :project, label: "PROJECT", as: :select
  filter :from_feedback, label: "FROM FEEDBACK", :collection => proc {(User.all).map{|c| [c.first_name, c.id]}}
  filter :guest_user, label: "GUEST USER", :collection => proc {(GuestUser.all).map{|c| [c.name]}}
  filter :approved, label: "APPROVED", as: :select,collection: %w[ Yes No ]


  index do
    selectable_column
    id_column
    column "Feedback Date" do |feed|
      date_time feed.created_at
    end
    column "Feedback From" do |feed|
      feed.given_by_name
    end
    column "Email" do |feed|
      feed.given_by_email
    end
    column "Feedback For" do |feed|
      feed.user.try(:full_name)
    end
    column "For Project" do |feed|
      feed.try(:project).try(:full_title)
    end
    column :approved
    # column :aggregate
    # column :quality_work
    # column :responsiveness
    # column :professionalism
    # column :expertise
    # column :cost
    # column :schedule
    # column :comment
    column :actions do |resource|
      links = ''.html_safe
      links += link_to I18n.t('active_admin.view'), resource_path(resource), :class => "member_link view_link"
      #links += link_to I18n.t('active_admin.edit'), edit_resource_path(resource), :class => "member_link edit_link"
      links += link_to I18n.t('active_admin.delete'), resource_path(resource), :method => :delete, :confirm => I18n.t('active_admin.delete_confirmation'), :class => "member_link delete_link"
      links += link_to "Make #{!resource.approved ? 'Approve' : 'DisApprove'}", approve_feedback_admin_feedback_path(resource), :method => :put, :class => "member_link"
      links
    end
  end

  show title:"Feedback" do |feed|
    attributes_table do
      row :id
      row :project
      row "Feedback Given By Name" do |f|
        f.given_by_name
      end
      row "Feedback Given By Email" do |f|
        f.given_by_email
      end
      row "Feedback For" do |f|
        f.user
      end
      row "Recommendation" do |f|
        f.aggregate
      end
      row :quality_work
      row :responsiveness
      row :professionalism
      row :expertise
      row :cost
      row :schedule
      row :comment
      row :approved
    end
  end

  csv do
    column "Feedback Date" do |feed|
      date_time feed.created_at
    end
    column "Feedback From" do |feed|
      feed.given_by_name
    end
    column "Emai" do |feed|
      feed.given_by_email
    end
    column "Feedback For" do |feed|
      feed.user.try(:full_name)
    end
    column "For Project" do |feed|
      feed.project.full_title if feed.project
    end
    column :aggregate
    column :quality_work
    column :responsiveness
    column :professionalism
    column :expertise
    column :cost
    column :schedule
    column :comment
    column :approved
  end


  permit_params :approved

  member_action :approve_feedback, :method => :put do
    feedback = Feedback.find(params[:id])
    if feedback.approved
      feedback.update_attribute(:approved,false)
      flash[:notice] = "Feedback disapproved successfully."
    else
      feedback.update_attribute(:approved,true)
      flash[:notice] = "Feedback approved successfully."
    end
    redirect_to :back
  end


end

ActiveAdmin.register Dispute do

  menu :parent => "Other Settings"
  actions :all, :except => [:new, :edit]
  filter :user, label: 'User', :collection => proc {(User.sellers.all).map{|c| [c.first_name, c.id]}}
  filter :project, label: 'Project', :collection => proc {(Project.all).map{|c| [c.title, c.id]}}
  config.batch_actions =false
  breadcrumb do
     [
       link_to('Admin', admin_root_path),
        link_to('Disputes', admin_disputes_path),
     ]   
   end 
  form do |f|
    render "form"
  end
  index do 
   selectable_column
    column :id
    column "Subject", sortable: :true do |p|
      p.subject
    end
    column "Project",sortable: :true do |p|
      p.project.title
    end
    column "Body" do |p|
      p.body 
    end
    column "Created At",sortable: :true do |p|
      p.created_at
    end
     column "Updated At",sortable: :true do |p|
      p.created_at
    end
    actions name:"Actions" 
  end
  controller do
    # def edit
    #   @dispute = Dispute.find(params[:id])
    # end

    def update
      @dispute = Dispute.find(params[:id])
      if @dispute.update_attributes(dispute_params)
        redirect_to admin_disputes_path
      else
        render 'edit'
      end
    end

    private

    def dispute_params
      params.require(:dispute).permit(:subject, :body ,:project_id, :user_id)
    end

  end
   member_action :show do 
    @page_title = "Dispute"
   end
end

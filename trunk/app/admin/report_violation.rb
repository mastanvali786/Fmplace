ActiveAdmin.register ReportViolation do

  menu :parent => "Other Settings"
  config.batch_actions = false
  actions :all, :except => [:new,:edit]

  actions :all, :except => [:new, :edit]

  filter :user, label: 'Freelancer Name', :collection => proc {(User.sellers.all).map{|c| [c.visible_name, c.id]}}
  filter :project, label: 'Project', :collection => proc {(Project.all).map{|c| [c.title, c.id]}}

  index do
    selectable_column
    column "Sent At" do |p|
      date_time p.created_at
    end
    column "Project" do |p|
      p.project.title
    end
    column "Subject" do |p|
      p.subject
    end
    column "Freelancer Name" do |p|
      p.user.visible_name if p.user.present?
    end
    column "From" do |p|
      p.project.buyer.full_name if p.project.present?
    end
    column "Body" do |p|
      p.body
    end
    actions name:"Actions"
  end
  show title:"Report Violation" do |feed|
    attributes_table do
      row :id
      row :subject
      row "Body" do |f|
        f.body
      end
      row "Project " do |f|
        f.project.title
      end
      row "Freelancer Name" do |report|
        report.user.visible_name if report.user.present?
      end
      row "From" do |report|
        report.project.buyer.full_name if report.project.present?
      end
      row "Bid Id" do |f|
        f.bid_id
      end
    end
  end



  csv do
    column "Sent At" do |report|
      date_time report.created_at
    end
    column "Project" do |report|
      report.project.title
    end
    column "Freelancer Name" do |report|
      report.user.visible_name if report.user.present?
    end
    column "From" do |report|
      report.project.buyer.full_name if report.project.present?
    end
    column "Subject" do |report|
      report.try(:subject)
    end
    column "Body" do |report|
      report.try(:body)
    end
  end

end

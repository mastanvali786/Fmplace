ActiveAdmin.register OnlineUser do

  scope :all, :default => true
  scope :guests
  scope :users
  scope :admin 

  #config.filters=false
  config.batch_actions = false

  filter :ip_address, label: 'Search By IP Address'
  filter :browser_name, label: 'Search By Browser Name'
  filter :platform, label: 'Search By OS'

  actions  :index, :show

  menu :parent => "Users", :label => 'Online Users'

  index do
    # selectable_column
    id_column
    column "User Type",:user_type
    column "User" do |online|
      if online.user_type == "USER"
        link_to online.user.visible_name, admin_user_path(online.user)
      elsif online.user_type == "ADMIN"
        link_to online.admin_user.visible_name, admin_admin_user_path(online.admin_user)
      else
        "----"
      end
    end
    column "IP Address", :ip_address
    column "Last Visited Url", :url
    column "Browser Name", :browser_name
    column "Browser Version", :browser_version
    column "Operating System", :platform
    column "Session Id", :session_id
  end

  csv do
    column "User Type" do |u|
      u.user_type
    end
    column "User" do |online|
      if online.user_type == "USER"
        online.user.visible_name
      elsif online.user_type == "ADMIN"
        online.admin_user.visible_name
      else
        "----"
      end
    end
    column "IP Address" do |u|
      u.ip_address
    end
    column "Last Visited Url" do |u|
      u.url
    end
    column "Browser Name" do |u|
      u.browser_name
    end
    column "Browser Version" do |u|
      u.browser_version
    end
    column "Operating System" do |u|
      u.platform
    end
    column "Session Id" do |u|
      u.session_id
    end
  end

end

ActiveAdmin.register AdminSetting, title:"Admin"  do
	menu :parent => "Other Settings"
	permit_params :first_name, :last_name, :email,:bid_fee
	config.filters = false
	actions :all, :except => [:new, :create, :update]


	breadcrumb do
		[
			link_to('Admin', '/admin'),
			link_to('AdminSetting','/admin/admin_settings')
		]
	end

	index :title=>"Admin Settings",:download_links=>false do
		selectable_column
		column :id
		column :first_name
		column :last_name
		column :email
		column "Bid fee", sortable: true do |amount|
			"#{DEFAULT_CURRENCY}#{amount.bid_fee}"
		end
		column :created_at
		column :updated_at
		actions name:"Actions"
	end
	show title:" " do
		panel "Admin Settings Details" do
			attributes_table_for admin_setting  do
				row :id
				row :first_name
				row :last_name
				row :email
				row "Bid fee", sortable: true do |amount|
					"#{DEFAULT_CURRENCY}#{amount.bid_fee}"
				end
				row :created_at
				row :updated_at
			end
		end
	end
	member_action :edit do
		@page_title="Edit Admin Settings"
	end
	
end
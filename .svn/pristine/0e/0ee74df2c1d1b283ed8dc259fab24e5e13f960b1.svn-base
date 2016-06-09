ActiveAdmin.register Report do
    menu :parent => "Reports",:label => " Freelancer"
    actions  :index
  
    config.filters = false
    show :title => "my_title_method" do
    # ...
    end
    controller do
     before_filter { @page_title = " Freelancers" }
        def index 
            redirect_to admin_freelancer_report_path
        end
        
        def freelancer_report
            @country = Country.all.order(:name)
            @plan = MembershipPlan.all.order(:id)
        end

        def freelancer_report_excel
            input_data, query = get_input_query(params)
            if input_data.length > 0
              input_data.unshift(query.chomp(" AND "))
              input_data = input_data.flatten
              @users = User.where(input_data)
                # if params[:referral] && params[:referral].present?
                #     if params[:referral] == "Non-referral"
                #         @users = @users.where('ref_id IS NULL')
                #     else
                #         @users = @users.where('ref_id IS NOT NULL')
                #     end
                # end
                if params[:plan] && params[:plan].present?
                    membership_plan = MembershipPlan.find(params[:plan].to_i)
                    @users = @users.select{|u| u.membership_plan.name == membership_plan.name}
                end
            end
            respond_to do |format|
                format.xlsx
            end
        end

        def get_input_query(params)
            query = ""
            input_data = []

            if params[:active_status] && params[:active_status].present?
                query += "is_active = ? AND "
                if params[:active_status] == "In-active"
                    active_status = false
                else
                    active_status = true
                end
                input_data << active_status
            end

            if params[:approved_status] && params[:approved_status].present?
                query += "approved = ? AND "
                if params[:approved_status] == "Approved"
                    approved = true
                else
                    approved = false
                end
                input_data << approved
            end

            if params[:country_id] && params[:country_id].present?
                query += "country_id = ? AND "
                input_data << params[:country_id].to_i
            end

            return input_data,query
        end
    end
end
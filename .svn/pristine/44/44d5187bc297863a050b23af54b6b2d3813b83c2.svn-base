ActiveAdmin.register MembershipPlan do
  menu :parent => "Membership Settings", label: "Membership Plan"
  config.batch_actions = false
  config.filters = false
  config.sort_order = "created_at_asc"
  actions :all, :except => [:new,:create,:destroy]

  index :download_links =>false do
    selectable_column
    #id_column
     column "Id", sortable: false do |plan|
        plan.id
      end
    column "Name", sortable: false do |plan|
      plan.name
    end
    column "Amount" do |plan|
      "#{DEFAULT_CURRENCY}#{plan.amount}"
    end
    actions name:"Actions"
  end

  show do
    attributes_table do
      row :name
      row "amount" do |plan|
        "#{DEFAULT_CURRENCY}#{plan.amount}"
      end
      row :highlight_skills
      row :higher_search
      row :team_count
      row :connects
      row :pricing_view
      row :feature_samples
      row :escrow_protection
      row :wire_transfer
      row "service_fee" do |plan|
        "#{DEFAULT_CURRENCY}#{plan.amount}"
      end
    end
  end

  controller do
      # def new
      #   @membership_plan = MembershipPlan.new
      # end

      # def create
      #   @membership_plan = MembershipPlan.new(membership_params)
      #   if @membership_plan.save
      #     redirect_to admin_membership_plans_path
      #   else
      #     render 'new'
      #   end
      # end

      def edit
        @membership_plan = MembershipPlan.find(params[:id])
      end

      def update
        @membership_plan = MembershipPlan.find(params[:id])
        if @membership_plan.update_attributes(membership_params)
          redirect_to admin_membership_plans_path
        else
          render 'edit'
        end
      end

      private

      def membership_params
        params.require(:membership_plan).permit(:name, :amount ,:highlight_skills, :showcase_portfolio, :higher_search, :team_count, :connects,:more_connects,:more_category,:pricing_view,:feature_samples,:escrow_protection,:wire_transfer,:service_fee)
      end
    end

    form do |f|
      render "form"
    end

 end



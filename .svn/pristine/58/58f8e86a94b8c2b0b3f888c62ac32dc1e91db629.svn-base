ActiveAdmin.register Payment do

  menu :parent => "Payment Module",:label => "Funded Payments"
  scope :all, :default => true
  scope :pending
  scope :approved
  scope :declined
  scope("Referral Bonus") { |scope| scope.where(type: "ReferalBonus") }

  COLOURS = ["Debit", "Credit", "ReferalBonus"]

  filter :type , as: :select , collection: proc { COLOURS }
  filter :created_at

  actions  :index

  index do
    selectable_column
    id_column
    column "Name",:sortable=>"users.first_name"  do |payment|
      payment.receiver.try(:full_name) 
    end
    column "Date Requested" do |payment|
      date_time payment.created_at
    end
    column "Role" do |payment|
      payment.receiver.role_name
    end
    column "Amount" do |payment|
    "#{DEFAULT_CURRENCY}#{payment.amount}"
    end
    column "Type" do |payment|
      payment.type
    end
    column :actions do |resource|
      links = ''.html_safe
      unless resource.declined || resource.approved
        if resource.type == "ReferalBonus"
          links += link_to "Add Bonus", approve_referal_bonus_admin_payment_path(resource), :method => :put, :class => "member_link"
          links += link_to "Declined", decline_referal_bonus_admin_payment_path(resource), :method => :put, :class => "member_link"
        else
          links += link_to "Approve", approve_payment_admin_payment_path(resource), :method => :put, :class => "member_link"
          links += link_to "Declined", declined_payment_admin_payment_path(resource), :method => :put, :class => "member_link"
        end
      end
      #links += link_to "View More", '#', onclick: "payment_details(#{resource.id});"
      links
    end
  end

  csv do
    column "ID" do |p|
       p.id
    end
    column "Name" do |p|
      p.receiver.try(:full_name) 
    end
    column "Date Requested" do |p|
      date_time p.created_at
    end
    column "Role" do |p|
      p.receiver.role_name
    end
    column "Amount" do |p|
       "#{DEFAULT_CURRENCY}#{p.amount}"
    end
    column "Type" do |p|
      p.type
    end
  end

  member_action :approve_payment, :method => :put do
    payment = Payment.find params[:id]
    if payment.approve!
      flash[:notice]  = "The payment has been processed successfully. " +
      "#{view_context.number_to_currency payment.amount} has been #{payment.type.downcase}ed to the receiver's balance."
    else
      flash[:notice]  = "Failed to approve payment.  Please try again later or contact appropriate persons"
    end
    redirect_to :back
  end

  member_action :declined_payment, :method => :put do
    payment = Payment.find params[:id]
    payment.update_attribute(:declined,true)
    flash[:notice] = "Payment declined successfully."
    redirect_to :back
  end

  member_action :approve_referal_bonus, method: :put do
    payment = Payment.find params[:id]
    if payment.approve_bonus!
      receiver = payment.receiver
      referrer = receiver
      if referrer.present?
        balance = referrer.balance
        balance.update_attributes(amount: balance.amount + 10)
        referrer.update_attributes(:referral_amount => referrer.referral_amount + 10)
        # referrer.increment!(:referral_amount, 10)
        flash[:notice]  = "The payment has been processed successfully. " + "#{view_context.number_to_currency payment.amount} has been added as referral's balance."
      end
    else
       flash[:notice]  = "Failed to approve payment.  Please try again later or contact appropriate persons"
    end
    redirect_to :back
  end

  member_action :decline_referal_bonus, method: :put do
    payment = Payment.find params[:id]
    payment.update_attribute(:declined,true)
    flash[:notice] = "Referral Bonus declined successfully."
    redirect_to :back
  end

  # Controller
  controller do 
     helper :authorize_net
    # Method to View Project in dashboard popup
    def payfast_withdrawals
      @request = WithdrawalRequest.find params[:id]
      @account_setting = @request.user.account_setting
      render layout: false
    end

    def authorize_credit_withdrawals
      @request = WithdrawalRequest.find params[:id]
      @account_setting = @request.user.account_setting
      render layout: false
    end
   def scoped_collection
    end_of_association_chain.includes([:receiver])
  end
  end

end

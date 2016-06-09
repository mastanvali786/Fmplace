ActiveAdmin.register WithdrawalRequest do

  menu :parent => "Payment Module",:label => "Withdraw Requests"
  actions  :index
  scope :pending, :default => true
  scope :completed
  scope :auto_withdrawals

  filter :user, label: 'Withdraw Requester', :collection => proc {(User.all).map{|c| [c.visible_name, c.id]}}

  index do
    selectable_column
    id_column
    column "Name" do |withdraw|
      withdraw.user.try(:visible_name) 
    end
    column "Date Requested" do |withdraw|
      withdraw.created_at
    end
    column "Amount" do |withdraw|
      number_to_currency withdraw.amount
    end
    column :actions do |request|
      # binding.pry
      links = ''.html_safe
      if request.pending?
        if request.invoiced?
          unless request.paid?
            if request.type == 'PayPalWithdrawalRequest'
              links += link_to "Make Payment", request.invoice.payer_view_url,:class => "member_link", target: '_new'
            else
              links += link_to "Make Payment",'#', onclick: "payfast_withdrawals(#{request.id});" 
            end
          end
        end
      end
      if request.completed?
        links += link_to I18n.t('active_admin.delete'), admin_withdrawal_request_path(request), :method => :delete, :confirm => I18n.t('active_admin.delete_confirmation'), :class => "member_link delete_link"
    end
    links
  end
  div id: "dialog-payfast" do
  end
end
controller do 
 def destroy
  @withdraw = WithdrawalRequest.find(params[:id])
  @withdraw.destroy
  redirect_to admin_withdrawal_requests_path
 end
end
csv do
  column "Name" do |w|
    w.user.try(:full_name) 
  end
  column "Date Requested" do |w|
    w.created_at
  end
  column "Amount" do |w|
    w.amount
  end
end

end

module Listeners
  class ProjectMilestone
    include Helper
    def new_milestone_funding_request(request)
      milestone = request.milestone
      settings = {current_url: milestone.current_url, paypal_ipn_url: milestone.paypal_ipn_url}
      @project = milestone.project
      @buyer = @project.buyer
      invoice = request.invoice! @buyer, settings
      @milestone_path = milestone_path milestone
      @invoice_url = link_to "invoice", "/milestones/invoice/#{invoice.id}"
      notify_seller if @project.seller?(request.sender)
      notify_buyer
    end
    private
    def notify_seller
      template = <<-EOL
        You have requested funds for #{@milestone_path}.
        An #{@invoice_url} has been sent.<br/>
        You will be notified when the funds have been received.
      EOL
      send_admin_message "Milestone Funding Requested", template, @project.seller.id
    end
    def notify_buyer
      @invoices_path = link_to "invoices", "/milestones/invoices"
      template = <<-EOL
        You are receiving an #{@invoice_url} to fund #{ @milestone_path }.
      EOL
      send_admin_message "Milestone Invoice", template, @buyer.id
    end
  end
end
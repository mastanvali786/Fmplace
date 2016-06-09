class EarningsController < ApplicationController
	before_filter :authenticate_user!

  def send_invoice
  	pids = current_user.bids.active.map(&:project_id)
    @projects =  Project.where(id: pids) if pids
  	@projects = @projects.awardcomplete.order('updated_at DESC').page(params[:page]).per(PER_PAGE_COUNT)
  end

end

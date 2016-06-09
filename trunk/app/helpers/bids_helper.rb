module BidsHelper
	
  ESTIMATED_DAYS = { 
   7 => "1 week",
   14 => "2 weeks",
   21 => "3 weeks",
   28 => "4 weeks",
   }
  def estimated_days_display(days)
    ESTIMATED_DAYS[days]
  end
  # following methods is for seller role only

  def bid_accepted?(project_id = 0)
    project = Project.find_by_id(project_id)
    if project.project_seller && project.project_seller.user.try(:id) == current_user.try(:id)
      return project.project_seller.bid.accepted
    else 
      return false
    end
  end

  def my_bid?(bid)
    bid.user.try(:id) == current_user.id
  end

  def bid_awarded?(project_id = 0)
    project = Project.find_by_id(project_id)
    if project.project_seller && project.project_seller.user.try(:id) == current_user.try(:id)
      return project.project_seller.bid.awarded
    else 
      return false
    end
  end

  def bid_declined?(project_id = 0)
    project = Project.find_by_id(project_id)
    if project.project_seller && project.project_seller.user.try(:id) == current_user.try(:id)
      return project.project_seller.bid.declined
    else 
      return false
    end
  end

  def bid_date(project_id = 0)
    if current_user.bids
      bid = current_user.bids.find_by_project_id(project_id)
      return bid.created_at
    end
  end

  def bid_awarded_date(project_id = 0)
    project = Project.find_by_id(project_id)
    if project.project_seller && project.project_seller.user.try(:id) == current_user.try(:id)
      return project.project_seller.bid.awarded_date
    else 
      return false
    end
  end

   def bid_accepted_date(project_id = 0)
    project = Project.find_by_id(project_id)
    if project.project_seller && project.project_seller.user.try(:id) == current_user.try(:id)
      return project.project_seller.bid.accepted_date
    else 
      return false
    end
  end

   def bid_declined_date(project_id = 0)
    project = Project.find_by_id(project_id)
    if project.project_seller && project.project_seller.user.try(:id) == current_user.try(:id)
      return project.project_seller.bid.declined_date
    else 
      return false
    end
  end

   # above methods is for contractor role only
  

end

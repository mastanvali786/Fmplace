class ApiController < ApplicationController

  def get_token
    render json: {result: true}
  end

  def dashboard_info
    user = User.find_by_id(params[:user_id])
    if params[:platform] == "mobileApp"
     if user && user.buyer?
       render json: {result: true, display_name: user.visible_name, my_projects_count: user.projects.try(:count),
        messages_count: user.message_count, find_freelancer_count: User.sellers.count}
      elsif user && user.seller?
        render json: {result: true, display_name: user.visible_name,my_projects_count: user.my_projects_count,
           messages_count: user.message_count,find_projects_count: Project.all.count}
       else
        render json: {result: false, msg: "User does not exists."}
      end
    end
  end
  
  def time_zones
    render json: {time_zones_list: ActiveSupport::TimeZone.zones_map.values.collect{|z| z.name} }
  end

  def get_categories
    render json: {cat_list: JSON.parse(Category.all.to_json(:only => [:id, :name])) }
  end

  def get_countries
    render json: {country_list: JSON.parse(Country.all.order('name ASC').to_json(:only => [:id, :name])) }
  end

  def get_project_tags
    render json: {tag_list: JSON.parse(ProjectTag.all.to_json(:only => [:id, :name])) }
  end

  def get_skills
    render json: {skill_list: JSON.parse(SkillTag.all.to_json(:only => [:id, :name])) }
  end

  def get_project_budgets
    fixed = ProjectBudget.where("name like ?", "%Fixed Price%").first
    hourly = ProjectBudget.where("name like ?", "%Hourly%").first
    @fixed_list = fixed.budget_options if fixed
    @hourly_list = hourly.budget_options if hourly
    render json: {fixed_list: JSON.parse(@fixed_list.to_json(:only => [:id, :name])),
     hourly_list: JSON.parse(@hourly_list.to_json(:only => [:id, :name])) }
   end

   def get_budgets_types
    render json: {budget_list: JSON.parse(ProjectBudget.all.to_json(:only => [:id, :name])) }
  end

  def get_project_framework
    render json: {framework_list: JSON.parse(ProjectTimeFrame.all.to_json(:only => [:id, :name])) }
  end

  def get_my_preferences
    render json: { cat_list: JSON.parse(Category.all.to_json(:only => [:id, :name])), user_cats: current_user.try(:category_ids),
     notify_category: current_user.try(:notify_category),
     time_zones_list: ActiveSupport::TimeZone.zones_map.values.collect{|z| z.name} }
  end

end

class TeamsController < ApplicationController

	def index
		@team_members = current_user.team_members
		if params[:fq] && params[:fq].length >=1
			@team_members = member_search(params[:fq], @team_members)
		end
	end

	def new
		@team_member = User.new
		@roles = Role.where('id NOT IN (:ids)', ids: [1,2])
	end

	def create
		@team_member = User.new(team_member_params)
		if @team_member.save
			redirect_to teams_path
			flash[:notice] = "Team Member is created successfully"
		else
			redirect_to teams_path
			flash[:error] = "Please Try again Later"
		end
	end

	def edit
		@team_member = User.find(params[:id])
		@roles = Role.where('id NOT IN (:ids)', ids: [1,2])
	end

	def update
		@team_member = User.find(params[:id])
		if @team_member.update_attributes(team_member_params)
			redirect_to teams_path
			flash[:notice] = "Team Member is updated successfully"
		else
			redirect_to teams_path
			flash[:error] = "Please Try again Later"
		end
	end

	def member_search(query,team_members)
		teams = User.arel_table
	    members = team_members.where("first_name LIKE ? or last_name LIKE ?", "%#{query}%", "%#{query}%")
	    unless members.present?
	    	members = []
	    	team_members.each do | f|
				if f.full_name == query
				    members << f
				end 
			end  
	    end
	    return members
	end


	private

	def team_member_params
		  params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :role_id, :user_id)
	end
end

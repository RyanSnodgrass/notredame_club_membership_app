class MembershipsController < ApplicationController

	def create
		# @club = Club.find(params[:club_id])
		# @user = User.find(params[:user_id])
		debugger
		@new_membership = Membership.new(membership_params)
		debugger
		if @new_membership.save
			redirect_to edit_club_path(params[:id])
		else
			redirect_to :back
		end
	end
		# if @club.memberships << @user

		# 	redirect_to edit_club_path(params[:id])
		# end
		# @new_membership = Membership.new(membership_params)

	def destroy
	end

	private

	def membership_params
		debugger
		params.require(:membership).permit(:user_id, :club_id)
	end
end
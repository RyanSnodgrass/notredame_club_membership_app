class MembershipsController < ApplicationController

	def create
		@new_membership = Membership.new(membership_params)
	end


	private

	def membership_params
		params.require(:membership).permit(:user_id, :club_id)
	end
end
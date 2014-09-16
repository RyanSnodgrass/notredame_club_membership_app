class MembershipsController < ApplicationController
  before_action :authenticate_user!

  def create
    # @club = Club.find(params[:club_id])
    # @user = User.find(params[:user_id])
    
    @new_membership = Membership.new(membership_params)
    
    if @new_membership.save
      redirect_to edit_club_path(params[:club_id])
    else
      redirect_to :back, notice: 'Whoopsies'
    end
  end
    # if @club.memberships << @user

    #   redirect_to edit_club_path(params[:id])
    # end
    # @new_membership = Membership.new(membership_params)

  def destroy
    @membership = Membership.find(params[:id])
    if @membership.destroy
      redirect_to edit_club_path(params[:club_id])
    else
      redirect_to :back
    end
    
  end

  private

  def membership_params

    params.require(:membership).permit(:user_id, :club_id)
  end
end
class MembershipsController < ApplicationController

  def create
    @group = Group.find(params[:group_id])
    @membership = @group.memberships.build(membership_params)
    if @membership.save
      flash[:notice] = "#{@membership.user.username}'s membership was created for #{@membership.group.title}!"
      redirect_to @membership.group
    else
      flash[:alert] = "That group couldn't be created for some reason."
      render "groups/admin_dashboard"
    end
  end

  private

  def membership_params
    params.require(:membership).permit(:user_id, :is_admin)
  end

end

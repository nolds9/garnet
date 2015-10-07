class StudentsController < ApplicationController
  def show
    @group = Group.find(params[:group_id])
    @author = Membership.find_by(user_id: current_user.id)
    @observation = @author.authored_observations.new

    @user = User.find(params[:id])
    @student = @group.members[@user.id]
    @membership = @group.memberships.exists?(user_id: @user.id)
    if @membership then @membership = @group.memberships.find_by(user_id: @user.id) end
  end
end

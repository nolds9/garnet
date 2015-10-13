class StudentsController < ApplicationController
  def show
    @group = Group.at_path(params[:group_path])
    @author = Membership.find_by(user_id: current_user.id)
    @observation = @author.authored_observations.new

    @student = User.find(params[:id])
    @membership = @group.memberships.find_by(user_id: @student.id)
  end
end

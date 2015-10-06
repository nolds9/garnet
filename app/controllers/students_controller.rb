class StudentsController < ApplicationController
  def index
    @group = Group.find(params[:group_id])
    @students = @group.members(is_admin?: false)
  end

  def show
    @group = Group.find(params[:group_id])
    @student = Membership.find(params[:id])
    @author = Membership.find_by(user_id: current_user.id)
    @observation = @author.authored_observations.new
  end
end

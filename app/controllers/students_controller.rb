class StudentsController < ApplicationController
  def index
    @group = Group.find(params[:group_id])
    @student_memberships = Membership.where(is_admin?: false, group_id: @group.id)
    student_id_array = @student_memberships.map(&:user_id)
    @students = student_id_array.map do |id|
      User.find(id)
    end
  end
  def show
    @group = Group.find(params[:group_id])
    @student = Membership.find(params[:id])
    @author = Membership.find_by(user_id: current_user.id)
    @observation = @author.authored_observations.new
  end
end

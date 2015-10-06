class StudentsController < ApplicationController
  def index
    @group = Group.find(params[:group_id])
    @memberships = @group.get_subgroups("memberships").where(is_admin?: false)
    @students = {}
    @memberships.each do |membership|
      id = membership.user.id
      if !@students.has_key?(id)
        @students[id] = {
          submissions: [],
          attendances: [],
          observations: []
        }
      end
      @students[id][:submissions].concat(membership.submissions)
      @students[id][:attendances].concat(membership.attendances)
      @students[id][:observations].concat(membership.student_observations)
    end
  end
  def show
    @group = Group.find(params[:group_id])
    @student = Membership.find(params[:id])
    @author = Membership.find_by(user_id: current_user.id)
    @observation = @author.authored_observations.new
  end
end

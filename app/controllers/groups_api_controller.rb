class GroupsApiController < ApplicationController

  def index
    @groups = Group.all

    render json: @groups
  end

  def groups_students
    group = Group.find(params[:id])
    students = group.memberships.where(is_admin?: false)
    render json: students
  end

end

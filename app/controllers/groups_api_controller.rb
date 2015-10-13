class GroupsApiController < ApplicationController

  def index
    @groups = Group.all

    render json: @groups
  end

  def students
    group = Group.at_path(params[:group_path])
    students = group.memberships.where(is_admin: false)
    render json: students
  end

  def students_attendances
    group = Group.at_path(params[:group_path])
    students = group.memberships.where(is_admin: false)

    summary = students.map do |student|
      student.get_attendance_summary
    end
    render json: summary
  end

  def students_submissions
    group = Group.at_path(params[:group_path])
    students = group.memberships.where(is_admin: false)

    summary = students.map do |student|
      student.get_submission_summary
    end
    render json: summary
  end

end

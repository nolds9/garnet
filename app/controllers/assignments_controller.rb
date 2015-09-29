class AssignmentsController < ApplicationController

  def index
    @group = Group.find(params[:group_id])
    @assignment  = Assignment.new
    @assignments = Assignment.where(group_id: @group.id)
  end

  def show
    @assignment = Assignment.find(params[:id])
  end

  def create
    @group = Group.find(params[:group_id])
    @assignment = @group.assignments.new(assignment_params)
    if @assignment.save
      redirect_to group_assignments_path(@group)
    end
  end

  private
    def assignment_params
      params.require(:assignment).permit(:title, :category, :repo_url, :due_date)
    end

end

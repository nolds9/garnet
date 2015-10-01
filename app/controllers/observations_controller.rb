class ObservationsController < ApplicationController
  def index
    @group = Group.find(params[:group_id])
    @student = Membership.find(params[:student_id])
    @observation = Observation.new
  end
  def create
    @group = Group.find(params[:group_id])
    @student = Membership.find(params[:membership_id])
    @observation = Observation.new observation_params
    if @observation.save
      redirect_to group_student_observations_path(@group, @student)
    end
  end
  private
  def observation_params
    params.require(:observation).permit(:body, :status)
  end
end

class ObservationsController < ApplicationController
  # def index
  #   @group = Group.find(params[:group_id])
  #   @student = Membership.find(params[:student_id])
  #   @observation = Observation.new
  # end
  def create
    @group = Group.find(params[:group_id])
    @student = Membership.find(params[:membership_id])
    @author = Membership.find_by(user_id: current_user.id)
    @observation = @author.authored_observations.new observation_params
    @observation.observee_id = @student.id
    binding.pry
    if @observation.save
      redirect_to group_student_path(@group, @student)
    end
  end
  private
  def observation_params
    params.require(:observation).permit(:body, :status, :membership_id)
  end
end

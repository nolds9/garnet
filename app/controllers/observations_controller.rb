class ObservationsController < ApplicationController
  def create
    @group = Group.at_path(params[:group_path])
    @student = Membership.find(params[:membership_id])
    @author = @group.memberships.find_by(user_id: current_user.id)
    @observation = @author.authored_observations.new observation_params
    @observation.observee = @student
    if @observation.save
      redirect_to group_student_path(@group, @student)
    end
  end
  private
  def observation_params
    params.require(:observation).permit(:body, :status)
  end
end

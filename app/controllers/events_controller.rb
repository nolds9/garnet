class EventsController < ApplicationController
  def index
    @events = Event.all
  end
  def create
    @event = Event.new event_params.merge(group_id: params[:group_id])
    if @event.save
      redirect_to group_event_path(params[:group_id], @event)
    else
      flash[:notice] = "Could not create event."
      redirect_to group_path params[:group_id]
    end
  end

  def show
    @event = Event.find(params[:id])
    @attendances =  @event.attendances.sort_by do |attendance|
      attendance.membership.user.username
    end

    # Find all 'students' for a given group, and order them by username TODO should be last_name
    # @students = group.memberships.where(is_admin?: false).joins(:user).order('users.username')
  end

  private
  
  def event_params
    params.require(:event).permit(:date)
  end
end

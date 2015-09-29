class EventsController < ApplicationController
  def index
    @events = Event.all
  end

  def show
    @event = Event.find(params[:id])
    @attendances =  @event.attendances.sort_by do |attendance|
      attendance.membership.user.username
    end

    # Find all 'students' for a given group, and order them by username TODO should be last_name
    # @students = group.memberships.where(is_admin?: false).joins(:user).order('users.username')
  end
end

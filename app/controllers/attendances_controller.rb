class AttendancesController < ApplicationController
  def update
    @attendance = Attendance.find(params[:id])
    @group = Group.find(params[:group_id])
    if @attendance.update(attendance_params)
      redirect_to group_event_path( @group, @attendance.event)
    end
  end
  private
  def attendance_params
    params.require(:attendance).permit(:status)
  end
end

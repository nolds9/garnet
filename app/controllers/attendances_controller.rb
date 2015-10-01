class AttendancesController < ApplicationController
  def update
    @attendance = Attendance.find(params[:id])
    @group = Group.find(params[:group_id])
    if @attendance.update(attendance_params)
      respond_to do |format| 
        format.json { render json: @attendance }
      end
    end
  end
  private
  def attendance_params
    params.require(:attendance).permit(:status)
  end
end

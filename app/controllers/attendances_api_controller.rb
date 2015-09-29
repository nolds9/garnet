class AttendancesApiController < ApplicationController
  def update
    @attendance = Attendance.find(params["attendance_id"])

    if @attendance.update(attendance_params)
      render json: @attendance
    end

  end

  private
  def attendance_params
    params.require(:attendance).permit(:status)
  end
end

class SubmissionsApiController < ApplicationController
  def index
    membership = Membership.find(params[:id])
    submissions = membership.submitted_submissions
    render json: submissions
  end

end

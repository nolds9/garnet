class SubmissionsApiController < ApplicationController
  def index
    membership = Membership.find(params[:id])
    submissions = membership.submissions
    render json: submissions
  end

end

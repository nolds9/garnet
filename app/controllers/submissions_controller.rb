class SubmissionsController < ApplicationController
  def index
    @membership = Membership.find(params[:id])
    @submissions = @mebership.submitted_submissions


  end
end

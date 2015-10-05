class MembershipsController < ApplicationController
  def show
    @student = Membership.find(params[:id])
  end
end

class MembershipsController < ApplicationController
  def show
    @student = Membership.find(params[:id]) #TODO: jsm moved to students controller, delete when workings
  end
end

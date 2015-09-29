class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate
  helper_method :current_user

  private
    def authenticate
      if !session[:user]
        redirect_to "/sign_in"
      end
    end

    def current_user
      return User.find(session[:user]["id"])
    end

end

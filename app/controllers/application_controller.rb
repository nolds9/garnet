class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  before_action :authenticate
  helper_method :current_user, :is_signed_in?

  private
    def authenticate
      if !current_user
        redirect_to "/sign_in"
      end
    end

    def set_current_user model
      cookies[:username] = model.username
      session[:user] = model
    end

    def current_user
      if signed_in?
        return User.find(session[:user]["id"])
      else
        return false
      end
    end

    def current_user_lean
      if session[:user]
        return session[:user]
      else
        return false
      end
    end

    def signed_in?
      if session[:user]
        return true
      else
        return false
      end
    end

end

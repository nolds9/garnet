class UsersController < ApplicationController

  skip_before_action :authenticate

  def sign_up
  end

  def sign_up!
    user = User.sign_up(params[:username], params[:password])
    if params[:password_confirmation] != params[:password]
      message = "Your passwords don't match!"
    elsif user.save
      message = "Your account has been created!"
    else
      message = "Your account couldn't be created. Did you enter a unique username and password?"
    end
    flash[:notice] = message
    sign_in!
  end

  def sign_in
  end

  def sign_in!
    if session[:user]
      @user = User.find_by(username: session[:user][:username])
    else
      @user = User.find_by(username: params[:username])
    end
    if !@user
      message = "This user doesn't exist!"
    elsif !@user.sign_in(params[:password])
      message = "Your password's wrong!"
    else
      cookies[:username] = @user.username
      session[:user]= @user
      message = "You're signed in, #{@user.username}!"
    end
    flash[:notice] = message
    redirect_to root_url
  end

  def sign_out
    reset_session
    message = "You're signed out!"
    flash[:notice] = message
    redirect_to root_url
  end

end

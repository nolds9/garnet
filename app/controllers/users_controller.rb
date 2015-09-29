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

  def gh_authorize
    redirect_to Github.new(ENV).oauth_link
  end

  def gh_authenticate
    github_instance = Github.new(ENV)
    github_instance.user_code = params[:code]
    session[:access_token] = github_instance.get_access_token
    refresh_github_info
  end

  def refresh_github_info
    gh_user = Github.new(ENV, session[:access_token]).api.user
    @user = User.find(session[:user]["id"])
    @user.update({
      github_id: gh_user["id"],
      github_username: gh_user["login"],
      image_url: gh_user["avatar_url"]
    })
    session[:user] = @user
    redirect_to :root
  end

end

class UsersController < ApplicationController

  skip_before_action :authenticate, except: [:show]

  def show
    @user = User.find_by(username: (params[:user] || current_user.username))
    @is_current_user = (@user.id == current_user.id)
  end

  def delete
    current_user.destroy
    reset_session
    redirect_to :root
  end

  def sign_up
    if current_user
      redirect_to :show
    end
  end

  def sign_up!
    user = User.sign_up(params[:username], params[:password])
    if params[:password_confirmation] != params[:password]
      message = "Your passwords don't match!"
    elsif user.save
      session[:user] = user
      message = "Your account has been created!"
      sign_in!
      return
    else
      message = "Your account couldn't be created. Did you enter a unique username and password?"
    end
    flash[:notice] = message
    redirect_to :sign_up
  end

  def sign_in
    if current_user
      redirect_to :show
    end
  end

  def sign_in!
    if current_user
      @user = current_user
    else
      @user = User.find_by(username: params[:username])
    end
    if @user && @user.sign_in(params[:password])
      cookies[:username] = @user.username
      session[:user] = @user
      flash[:notice] = "You're signed in, #{@user.username}!"
      if @user.memberships.length <= 1 || @user.memberships[0].is_admin?
        redirect_to groups_path
      else
        redirect_to "/report_card/#{@user.groups[0].id}"
      end
    else
      flash[:alert] = "Your password's wrong, or that user doesn't exist."
      render :sign_in
    end
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
    gh_params = {
      github_id: gh_user["id"],
      username: gh_user["login"],
      image_url: gh_user["avatar_url"]
    }
    if current_user
      @user = current_user
    elsif User.exists?(github_id: gh_user["id"])
      @user = User.find_by(github_id: gh_user["id"])
    else
      @user = User.create(gh_params)
    end
    @user.update(gh_params)
    session[:user] = @user
    redirect_to :root
  end

end

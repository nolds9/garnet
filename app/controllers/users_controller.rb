class UsersController < ApplicationController

  skip_before_action :authenticate, except: [:show]

  def show
    @user = User.find_by(username: (params[:user] || current_user.username))
    @is_current_user = (@user.id == current_user.id)
  end

  def update
    if params[:password_confirmation] != params[:password]
      flash[:alert] = "Your passwords don't match!"
    else
      user = current_user.save_params(params)
      if user && user.save!
        flash[:notice] = "Account updated!"
      else
        flash[:notice] = "Since you're using Github, you'll need to make all your changes there."
      end
    end
    redirect_to :back
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
    user = User.new
    if params[:password_confirmation] != params[:password]
      flash[:alert] = "Your passwords don't match!"
      render :sign_up
    elsif user.save_params(params).save!
      session[:user] = user
      flash[:notice] = "Your account has been created!"
      sign_in!
    else
      flash[:alert] = "Your account couldn't be created. Did you enter a unique username and password?"
      render :sign_up
    end
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
    if @user && !@user.github_id && @user.password_ok?(params[:password])
      cookies[:username] = @user.username
      session[:user] = @user
      flash[:notice] = "You're signed in, #{@user.username}!"
      redirect_to "/profile"
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
      image_url: gh_user["avatar_url"],
      name: gh_user["name"],
      email: gh_user["email"]
    }
    if current_user
      @user = current_user
    elsif User.exists?(github_id: gh_user["id"])
      @user = User.find_by(github_id: gh_user["id"])
    else
      @user = User.create!(gh_params)
    end
    @user.update!(gh_params)
    session[:user] = @user
    redirect_to :root
  end

  private
  def user_params
    if @user.github_id
      params.require(:user).permit(:password, :password_confirmation)
    else
      params.require(:user).permit(:password, :password_confirmation, :username, :name, :email)
    end
  end

end

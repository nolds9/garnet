class GroupsController < ApplicationController
  # before_action :check_for_single_group, only: [:index]

  def index
  end

  def admin_dashboard group
    @group = group
    @students = @group.members(is_admin?: false)
    render "admin_dashboard"
  end

  def report_card group, user
    @user = user
    @group = group
    @student = @user.memberships.find_by(group_id: @group.id)
    @attendances = @student.get_subgroups("attendances")
    @submissions = @student.get_subgroups("submissions")
    render "report_card"
  end

  def show
    @group = Group.find(params[:id])
    if @group.memberships.exists?(user_id: current_user.id, is_admin?: true)
      admin_dashboard(@group)
    elsif @group.memberships.exists?(user_id: current_user.id)
      report_card(@group, current_user)
    else
      @admins = @group.memberships.where(is_admin?: true).map{|m| m.user}
    end
  end

  def new
    @group = Group.new
    render "new"
  end

  def edit
    @group = Group.find(params[:id])
    render "edit"
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      flash[:notice] = "#{@group.title} was created!"
      render "show"
    else
      flash[:alert] = "That group couldn't be created for some reason."
      render "new"
    end
  end

  def update
    @group = Group.find(params[:id])
    if @group.update(group_params)
      flash[:notice] = "#{@group.title} was updated!"
      redirect_to "show"
    else
      flash[:alert] = "That group couldn't be updated."
      render "edit"
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    render "index"
  end

  private
    def group_params
      params.require(:group).permit(:title, :category)
    end

    def check_for_single_group
      if current_user.groups.length == 1
        redirect_to action: 'report_card', id: current_user.groups[0].id
      end
    end

end

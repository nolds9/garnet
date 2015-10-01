class GroupsController < ApplicationController

  def index
    category = params[:category]
    if category
      @groups = Group.find_by(category: category)
    else
      @groups = Group.all
    end
    render "index"
  end

  def show
    @group = Group.find(params[:id])
    @event = Event.new
    # TODO:Exract these into helper methods for use throughout the application
    @student_memberships = Membership.where(is_admin?: false, group_id: @group.id)
    student_id_array = @student_memberships.map(&:user_id)
    @students = student_id_array.map do |id|
      User.find(id)
    end

    @instructor_memberships = current_user.memberships
    puts current_user.memberships
    group_id_array = @instructor_memberships.map(&:group_id)
    @groups = group_id_array.map do |id|
      Group.find(id)
    end

    render "show"
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

end

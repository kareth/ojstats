class GroupsController < ApplicationController
  before_filter :authorize_creator, only: [:edit, :update, :destroy]
  before_filter :authorize_user
  def index
    @groups = Group.all
  end

  def show
    @group = Group.find(params[:id])
  end

  def new
    @group = Group.new
  end

  def edit
    @group = Group.find(params[:id])
  end

  def create
    @group = Group.new(params[:group])
    @group.creator_id = current_user.id
    if @group.save
      redirect_to current_stage_group_path(@group), notice: 'Group was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @group = Group.find(params[:id])

    if @group.update_attributes(params[:group])
      redirect_to current_stage_group_path(@group), notice: 'Group was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to groups_url
  end

  def join
    @group = Group.find(params[:id])
    @group.users << current_user
    redirect_to current_stage_group_path(@group), notice: "Succesfully joined group"
  end

  def leave
    @group = Group.find(params[:id])
    @group.users.delete current_user
    redirect_to groups_path(@group), notice: "Succesfully left group"
  end

  def current_stage
    @group = Group.find(params[:id])
    @stage = @group.current_stage
    unless @stage
      return redirect_to all_stages_group_url(@group), alert: "There is no ongoing stage in the group"
    end
    @ranking = GroupRanking.new(@group, @stage)
    @time_left = ((@stage.end_time - DateTime.now.utc) * 24 * 60 * 60).to_i
  end

  def all_stages
    @group = Group.find(params[:id])
    @ranking = GroupRanking.new(@group)
  end

  private

  def authorize_creator
    @group = Group.find(params[:id])
    unless @group.created_by? current_user
      redirect_to root_url, alert: "You cannot manage this group"
    end
  end
end

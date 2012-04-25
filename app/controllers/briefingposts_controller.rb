class BriefingpostsController < ApplicationController
  before_filter :authenticate_user!, :only => [:create, :edit, :update, :deactive]
  def index
    if params[:area].blank?
      @briefingposts = Briefingpost.briefing_posts(params[:date], params[:shift], params[:page])
    else
      @briefingposts = Briefingpost.area_briefing_posts(params[:date], params[:area], params[:page])
    end
  end

  def show
    @briefingpost = Briefingpost.find(params[:id])
  end

  def create
    @briefingpost  = current_user.briefingposts.build(params[:briefingpost])
    @briefingpost.is_active = true
    if @briefingpost.save
      flash[:notice] = "A briefing notice created!"
      redirect_to briefingposts_path
    else
      error_msg = ""
      @briefingpost.errors.full_messages.each do |msg|
        error_msg << msg + "\n"
      end
      flash[:error] = error_msg
      render new_briefingpost_path
    end
  end
  
  def edit
    @briefingpost = Briefingpost.find(params[:id])
    local_date = @briefingpost.active_date.in_time_zone('Hanoi').to_date
    if (local_date < Date.today)
      redirect_to briefingposts_path, notice: "No update for past date briefings"
    end
  end
  
  def update
    @briefingpost = Briefingpost.find(params[:id])
    if (current_user)
      @briefingpost.update_attributes(params[:briefingpost])
      redirect_to briefingpost_path(@briefingpost), notice: "A briefing notice updated!"
    else
      redirect_to briefingposts_path, error: "Nothing updated!"
    end
  end
  
  # update is_active=false is a delete
  def deactive
    authorize! :deactive, @user, :message => 'Not authorised to remove a briefing.'
    briefingpost = Briefingpost.find(params[:id])
    local_date = briefingpost.active_date.in_time_zone('Hanoi').to_date
    if ((current_user.has_role? :supervisor) && local_date >= Date.today)
      briefingpost.update_attribute(:is_active, false)
      redirect_to briefingposts_path, notice: "A briefing notice deleted!"
    else
      redirect_to briefingposts_path, error: "Nothing updated!"
    end
  end
end
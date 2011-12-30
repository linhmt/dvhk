class BriefingpostsController < ApplicationController
  before_filter :authenticate_user!, :only => [:create]

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
    if @briefingpost.save

      flash[:notice] = "Briefingpost created!"
      redirect_to briefingposts_path
    else
      flash[:error] = "Error!"
      render new_briefingpost_path
    end
  end
  
  def edit
    @briefingpost = Briefingpost.find(params[:id])
  end
  
  # update is_active=false is a delete
  def update
    briefingpost = Briefingpost.find(params[:id])
    if (params[:is_active].present?)
      briefingpost.update_attribute(:is_active, false)
      redirect_to briefingposts_path, notice: "A briefing notice deleted!"
    end
  end
end

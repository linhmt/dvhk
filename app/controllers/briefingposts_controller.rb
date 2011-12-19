class BriefingpostsController < ApplicationController
  before_filter :authenticate_user!, :only => [:create]

  def index
    params[:date].nil? ? active_date = Passenger.midnight_local_to_utc : active_date = Time.zone.parse(params[:date]).utc
    @briefingposts = Briefingpost.where("active_date >= ? AND active_date < ?", active_date, active_date.advance({:days => +1})).page(params[:page])
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
end

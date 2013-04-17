require 'spreadsheet'

class DataFilesController < ApplicationController
  def index
    authorize! :index, @user, :message => 'Not authorized as an administrator.'
  end

  def show
  end
  
  def new
    @data_file = DataFile.new
  end

  def shift_tracking
    @data_file = DataFile.new
  end
  
  def create_shift_tracking
    @file = DataFile.create(params[:data_file])
    @file.shift_tracking_file(params[:standard_day_off].to_i)
    redirect_to shift_trackings_path
  end
  
  def day_off
    @data_file = DataFile.new
  end
  
  def create_day_off
    @file = DataFile.create(params[:data_file])
    @file.day_off_file
    redirect_to shift_trackings_path
  end
  
  def create  
    @file = DataFile.create(params[:data_file])
    if (@file.nil?)
      flash[:error] = "The flights are NOT loaded."
      render :action => "new"
    else
      @file.dailyroster_file
      flash[:notice] = "The flights are loaded succesfully."
      redirect_to arrival_flights_path
    end
  end
end

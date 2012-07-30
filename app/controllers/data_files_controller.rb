class DataFilesController < ApplicationController
  def index
  end

  def show
  end
  
  def new
    @data_file = DataFile.new
  end

  def create  
    @file = DataFile.create(params[:data_file])
    if (@file.nil?)
      flash[:notice] = "The flights are loaded succesfully."
      render :action => "new"
    elsif (@file.is_arrival == true)
      flash[:notice] = "The arrival flights are loaded succesfully."
      redirect_to arrival_flights_path
    else
      flash[:notice] = "The departure flights are loaded succesfully."
      redirect_to flights_path
    end
  end
end

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
    if (!@file.nil? && params[:data_file][:is_arrival])
      flash[:notice] = "The flight was saved succesfully."
      redirect_to arrival_flights_path
    end
  end
end

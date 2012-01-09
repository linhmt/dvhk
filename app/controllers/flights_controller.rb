class FlightsController < ApplicationController
  before_filter :authenticate_user!
  def index
    @flights = Flight.page(params[:page])
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  def new
    @flight = Flight.new()
    respond_to do |format|
      format.html # new.html.erb
    end
  end
  
  def create
    @flight = current_user.flights.build(params[:flight])
    if @flight.save
      redirect_to flight_path(@flight), notice: 'Flight was successfully created.'
    else
      render action: "new"
    end
  end
  
  def show
    @flight = Flight.find(params[:id])
  end
  
  def edit
    @flight = Flight.find(params[:id])
  end
  
  def update
    @flight = Flight.find(params[:id])

    if @flight.update_attributes(params[:flight])
      redirect_to flight_path(@flight), notice: 'Flight was successfully updated.'
    end
  end
end
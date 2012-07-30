class FlightsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]
  def index
    @flights = Flight.flights(params[:date], params[:is_domestic], params[:page])
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
  
  def edit_individual
    @flights = Flight.find(params[:flight_ids])
    if params[:assign] == "Assign Checked"
      render action: "assign"
    end
  end

  def update_individual
    Flight.update(params[:flights].keys, params[:flights].values)
    redirect_to flights_path, notice: "Flights updated!!!"
  end
  
  def assign
  end
  
  def update_multiple
    flights = Flight.find(params[:flight_ids])
    flights.each do |flight|
      flight.user_id = params[:user_id]
      flight.save!
    end
    user = User.find(params[:user_id])
    redirect_to flights_path, notice: "Flights are assigned to #{user.name}"
  end
end
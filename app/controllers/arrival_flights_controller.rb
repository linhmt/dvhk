class ArrivalFlightsController < ApplicationController
  before_filter :authenticate_user!, :except => :index
  
  def index
    @arrival_flights = ArrivalFlight.arrival_flights(params[:date], params[:page])
  end

  def show
    @arrival_flight = ArrivalFlight.find(params[:id])
  end
  
  def new
    @arrival_flight = ArrivalFlight.new
  end

  def create  
    @arrival = current_user.arrival_flights.build(params[:arrival_flight])
    puts @arrival.inspect
    if @arrival.save
      flash[:notice] = "The flight was saved succesfully."
      redirect_to :action => "index"
    else
      render :action => "new"
    end
  end

  def edit
    @arrival_flight = ArrivalFlight.find(params[:id])
  end

  def update
    
  end

  # update is_active=false is a delete
  def deactive
    
  end
end

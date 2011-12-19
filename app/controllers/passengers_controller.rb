class PassengersController < ApplicationController
  before_filter :authenticate_user!

  def index
    @routing = Routing.find(params[:routing_id])
    @passengers = @routing.standby_passengers(params[:page])
    @routings = Routing.all
  end
  
  def show_accepted
    @routing = Routing.find(params[:routing_id])
    @passengers = @routing.accepted_passengers
    @routings = Routing.all
  end

  def show
    @passenger = Passenger.find(params[:id])
  end

  # GET /passengers/new
  # GET /passengers/new.json
  def new
    @passenger = Passenger.new({:routing_id => params[:routing_id], 
        :priority_id => 11})

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @passenger }
    end
  end

  # GET /passengers/1/edit
  def edit
    @passenger = Passenger.find(params[:id])
  end

  # POST /passengers
  # POST /passengers.json
  def create
    @passenger = current_user.passengers.build(params[:passenger])

    if @passenger.save
      redirect_to routing_passenger_path(@passenger.routing, @passenger), notice: 'Passenger was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /passengers/1
  def update
    @passenger = Passenger.find(params[:id])

    if @passenger.update_attributes(params[:passenger])
      redirect_to routing_passenger_path(@passenger.routing, @passenger), notice: 'Passenger was successfully updated.'
    end
  end
  
  def accept_selected
    if (current_user && !params[:standby_flight].blank?)
      @passengers = Passenger.where(:id => params[:pax_ids])
      @passengers.each do |passenger|
        passenger.accept_go_show(params[:standby_flight], current_user)
      end
      respond_to do |format|
        format.js 
        format.html {redirect_to routing_passengers_path(params[:routing_id])}
      end
    else
      render :nothing => true
    end
  end
  
  def accept
    @passenger = Passenger.where(:id => params[:id]).first
    if (current_user && !params[:standby_flight].blank?)
      @passenger.accept_go_show(params[:standby_flight], current_user)
      respond_to do |format|
        format.js 
        format.html {redirect_to routing_passengers_path(@passenger.routing)}
      end
    else
      render :nothing => true
    end
  end
end

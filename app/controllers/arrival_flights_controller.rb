include ApplicationHelper
include ActionView::Helpers::TagHelper
class ArrivalFlightsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show, :history]

  def index
    if (!params[:is_approval].nil? && !params[:is_approval].to_bool)
      @arrival_flights = ArrivalFlight.open_flights(
        params[:date],
        params[:user_id],
        params[:page])
    elsif (!params[:flight_no].blank?)
      @arrival_flights = ArrivalFlight.search_flight(params[:date], params[:flight_no])
    else
      @arrival_flights = ArrivalFlight.arrival_flights(params[:date], params[:is_domestic], params[:page])
    end
    respond_to do |format|
      format.html
      format.xls
    end
  end

  def show
    @arrival_flight = ArrivalFlight.find(params[:id])
  end

  def history
    @key_flight = ArrivalFlight.find(params[:id])
    @audits = @key_flight.audits
  end
  
  def new
    @arrival_flight = ArrivalFlight.new
    @arrival_flight.flight_date = Date.today
  end

  def create
    @arrival = current_user.arrival_flights.build(params[:arrival_flight])
    if @arrival.save!
      flash[:notice] = "The flight was saved succesfully."
      redirect_to :action => "index"
    else
      render :action => "new"
    end
  end

  def edit
    @arrival_flight = ArrivalFlight.find(params[:id])
    @arrival_flight.outbound_tags = retrieve_all_outbounds(@arrival_flight)
  end

  def update
    arrival_flight = ArrivalFlight.find(params[:id])
    arrival_flight.attributes=(params[:arrival_flight])
    if (arrival_flight.remarks_changed? && !arrival_flight.remarks.blank?)
      arrival_flight.update_new_remark(params[:arrival_flight][:remarks], current_user)
    end
    ob_tags = params[:arrival_flight][:outbound_tags]
    params[:arrival_flight].delete :outbound_tags
    arrival_flight.attributes=(params[:arrival_flight])
    arrival_flight.outbound_tags=(ob_tags)
    if arrival_flight.save!
      redirect_to arrival_flight_path(arrival_flight), notice: "#{arrival_flight.flight_no} was successfully updated."
    end
  end

  # update is_active=false is a delete
  def deactive
    r_date = Date.today
    if current_user.has_role?(:assign_roster, ArrivalFlight)
      @flight = ArrivalFlight.find(params[:id])
      @flight.update_attribute(:is_active, false)
      @flight.save!
      r_date = @flight.flight_date
    end
    redirect_to arrival_flights_url(:date => r_date)
  end
  
  def revert
    if current_user.has_role?(:assign_roster, ArrivalFlight)
      @flight = ArrivalFlight.find(params[:id])
      @flight.update_attribute(:is_approval, false)
      @flight.save!
    end
    redirect_to arrival_flight_url(@flight), notice: "This flight is reverted to OPEN now!"
  end

  def edit_individual
    if params[:arrival_flight_ids].blank?
      redirect_to arrival_flights_url(:date => params[:date]), notice: "Please choose at least one flight"
    else      
      @arrival_flights = ArrivalFlight.find(params[:arrival_flight_ids])
      if params[:assign] == "Assign Checked"
        render action: "assign_flights"
      elsif params[:approval] == "Review Checked"
        render action: "approval_flights"
      end
    end
  end

  def update_individual
    ArrivalFlight.update(params[:arrival_flights].keys, params[:arrival_flights].values)
    redirect_to arrival_flights_path(:date => params[:date]), notice: "Arrival flights updated!"
  end
  
  def assign
    arrival_flight = ArrivalFlight.find(params[:id]) unless current_user.nil?
    arrival_flight.user_id = current_user.id
    arrival_flight.save!
    redirect_to arrival_flight_path(arrival_flight), notice: "Flight #{arrival_flight.flight_no} is assigned to #{current_user.name}"
  end
  
  def open
    @records = ArrivalFlight.open_flight_dates
  end

  def assign_flights
  end
  
  def approval_flights
  end

  def update_multiple
    arrival_flights = ArrivalFlight.find(params[:arrival_flight_ids])
    arrival_flights.each do |arrival_flight|
      arrival_flight.user_id = params[:user_id]
      arrival_flight.lnf_user_id = params[:lnf_user_id]
      arrival_flight.save!
    end
    user1 = User.find(params[:user_id])
    user2 = User.find(params[:lnf_user_id]) unless params[:lnf_user_id].blank?
    unless user2.blank?
      notice = "Flights are assigned to #{user1.name} and #{user2.name}"
    else
      notice = "Flights are assigned to #{user1.name}"
    end
    redirect_to arrival_flights_path(:date => params[:date]), notice: notice
  end
  
  def approval_multiple
    if (current_user && current_user.has_role?(:supervisor))
      arrival_flights = ArrivalFlight.find(params[:arrival_flight_ids])
      if params[:disapproval_all] == "Disapproval All"
        current_user.disapproval_arrival_flights(arrival_flights, params[:comment])
        redirect_to arrival_flights_path, notice: "Flights are rejected, and email sent."
      else
        arrival_flights.each do |arrival_flight|
          arrival_flight.approval_flight(current_user)
        end
        redirect_to arrival_flights_path, notice: "Flights are accepted and finalised."
      end
    else
      redirect_to arrival_flights_path
    end
  end
  
  def assigned
    if current_user
      params[:date].blank? ? date = Date.today : date = Date.parse(params[:date])
      @arrival_flights = current_user.arrival_flights.where(:flight_date => date)
    end
  end
  
  def destroy

  end
end
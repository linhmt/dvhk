class OutboundsController < ApplicationController
  def index
    @arrival_flight = ArrivalFlight.find(params[:arrival_flight_id])
    @outbounds = @arrival_flight.outbounds
  end
end

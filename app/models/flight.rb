class Flight < ActiveRecord::Base
  belongs_to :user
  belongs_to :routing
  before_save :update_is_domestic
  
  def self.flights(date, is_domestic = nil, page)
    flight_date = ArrivalFlight.retrieve_flight_date(date)
    condition = {
      :flight_date => flight_date.midnight.utc..flight_date.end_of_day.utc
    }
    if is_domestic.nil?
      Flight.where(condition).page(page).per(50)
    else
      Flight.where(condition).where(:is_domestic => is_domestic.to_bool).page(page).per(50)
    end
  end
  
  def update_is_domestic
    temp = self.flight_no.slice(2)
    self.is_domestic = (self.flight_no.length == 6 && (temp.to_i == 1 || temp.to_i == 7))
    true
  end
end

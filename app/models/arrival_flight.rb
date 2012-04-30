class ArrivalFlight < ActiveRecord::Base
  belongs_to :user;
  belongs_to :routing;
  validates :flight_no, :flight_date, :presence => true
  attr_accessible :reg_no, :routing_id, :flight_no, :flight_date, :sta, :eta, :ata
  
  def self.arrival_flights(date, page)
    flight_date = ArrivalFlight.retrieve_flight_date(date)
    condition = {
      :flight_date => flight_date.midnight.utc..flight_date.end_of_day.utc
    }
    ArrivalFlight.where(condition).page(page)
  end
  
  private
  def self.retrieve_flight_date(date)
    Time.zone=('Hanoi')
    if date.nil?
      date = DateTime.now.to_date.to_s
    end
    a_date = Time.zone.parse(date)
    a_date
  end
end

class Routing < ActiveRecord::Base
  has_many :passengers
  has_many :arrival_flights
  has_many :flights

  def accepted_passengers
    midnight = Passenger.midnight_local_to_utc
    end_of_day = Passenger.end_of_day_local_to_utc
    pax_list = passengers.where("accepted IS TRUE AND created_at >= ? and created_at <= ?", midnight, end_of_day)
    pax_list
  end
  
  # display list of cleared passengers of a routing for the current day
  def cleared_passengers
    midnight = Passenger.midnight_local_to_utc
    end_of_day = Passenger.end_of_day_local_to_utc
    pax_list = passengers.where("accepted IS NOT TRUE AND called IS TRUE AND created_at >= ? and created_at <= ?", midnight, end_of_day)
    pax_list
  end
  
  def standby_size
    midnight = Passenger.midnight_local_to_utc
    end_of_day = Passenger.end_of_day_local_to_utc
    passengers.where("accepted IS NOT TRUE AND called IS NOT TRUE AND created_at >= ?  and created_at <= ?", midnight, end_of_day).count
  end
  
  def standby_passengers(page)
    midnight = Passenger.midnight_local_to_utc
    end_of_day = Passenger.end_of_day_local_to_utc
    pax_list = passengers.joins(:priority).where("accepted IS NOT TRUE AND called IS NOT TRUE AND passengers.created_at >= ? and passengers.created_at <= ?", midnight, end_of_day).order('pri_level asc, sequence asc').page(page)
    pax_list
  end
  
  def current_priority_maximum(prioirity_id)
    midnight = Passenger.midnight_local_to_utc
    end_of_day = Passenger.end_of_day_local_to_utc
    max_seq = passengers.where({:priority_id => prioirity_id, :created_at => midnight..end_of_day}).maximum('sequence')
    if max_seq.blank?
      return 0
    else
      return max_seq
    end
  end
end

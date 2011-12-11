class Passenger < ActiveRecord::Base
  validates :pax_name, :presence => true
  belongs_to :routing
  belongs_to :priority
  belongs_to :user
  before_save :upcase_fields
  before_save :set_priority_sequence
  
  def accept_go_show(on_flight, user_id)
    on_flight.gsub!(/([a-zA-Z]*)(\d{3,})([a-zA-Z]*)/, '\2')
    self.update_attributes(
      :accepted => true, 
      :called => true,
      :user_id => user_id,
      :accepted_flt => on_flight
    )
  end
  
  def self.midnight_local_to_utc
    m = Time.now.in_time_zone('Hanoi').midnight
    m.utc
  end

  def self.end_of_day_local_to_utc
    m = Time.now.in_time_zone('Hanoi').end_of_day
    m.utc
  end
  
  def upcase_fields
    self.pax_name = pax_name.upcase
    self.personal_id = personal_id.upcase
    self.ticket_class = ticket_class.upcase
  end
  
  def set_priority_sequence
    if (self.sequence.nil? || self.routing_id_changed? || self.priority_id_changed?)
      self.sequence = self.routing.current_priority_maximum(self.priority_id) + 1
    end
  end
  
end

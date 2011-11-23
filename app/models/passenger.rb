class Passenger < ActiveRecord::Base
  validates :pax_name, :ticket_class, :presence => true
end

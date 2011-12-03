class Passenger < ActiveRecord::Base
  validates :pax_name, :ticket_class, :presence => true
  belongs_to :routing
  belongs_to :priority
  belongs_to :user
end

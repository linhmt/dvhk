class Outbound < ActiveRecord::Base
  belongs_to :arrival_flight
  default_scope :order => 'flight_no asc'
end

include ActionView::Helpers::SanitizeHelper

class ArrivalFlight < ActiveRecord::Base
  belongs_to :user
  belongs_to :routing
  has_many :outbounds, :dependent => :destroy
  validates :flight_no, :flight_date, :sta, :presence => true
  default_scope :order => 'sta asc'
  attr_accessor :outbound_tags, :sta_arrnextday, :eta_arrnextday, :ata_arrnextday
  before_save :update_internal_attributes
  after_save :generate_outbound
  
  def self.arrival_flights(date, is_domestic, page)
    flight_date = ArrivalFlight.retrieve_flight_date(date)
    condition = {
      :flight_date => flight_date.midnight.utc..flight_date.end_of_day.utc
    }
    if is_domestic.nil?
      ArrivalFlight.where(condition).page(page).per(50)
    else
      ArrivalFlight.where(condition).where(:is_domestic => is_domestic.to_bool).page(page).per(50)
    end
  end
  
  def self.open_flights(date, page)
    flight_date = ArrivalFlight.retrieve_flight_date(date)
    condition = {
      :is_approval => false,
      :flight_date => flight_date.midnight.utc..flight_date.end_of_day.utc
    }
    ArrivalFlight.where(condition).page(page).per(50)
  end
  
  def update_internal_attributes
    self.flight_no = self.flight_no.upcase
    self.is_domestic = update_is_domestic
    self.sta = adjust_arrival_time(self.flight_date, self.sta, self.sta_arrnextday)
    self.eta = adjust_arrival_time(self.flight_date, self.eta, self.eta_arrnextday)
    self.ata = adjust_arrival_time(self.flight_date, self.ata, self.ata_arrnextday)
    true
  end
    
  def adjust_arrival_time(date_t, time_t, arrnextday)
    if (!time_t.nil?)
      if (!arrnextday.nil? && arrnextday)
        time_temp = Time.new(date_t.year, date_t.month, date_t.day, time_t.hour, time_t.min)
        adjusted_time = time_temp.advance(:days => +1)
      else
        adjusted_time = Time.new(date_t.year, date_t.month, date_t.day, time_t.hour, time_t.min).utc
      end
    end
    adjusted_time
  end
  
  def update_is_domestic
    temp = self.flight_no.slice(2)
    domestic = (self.flight_no.length == 6 && (temp.to_i == 1 || temp.to_i == 7))
    domestic
  end

  def self.retrieve_flight_date(date)
    Time.zone=('Hanoi')
    if date.nil?
      date = Date.today.to_s
    end
    a_date = Time.zone.parse(date)
    a_date
  end
  
  def approval_flight(current_user)
    self.is_approval = true
    self.approval_by = current_user.id
    self.save!
  end
  
  private
  def generate_outbound
    unless outbound_tags.nil?
      outbound = strip_tags(outbound_tags)
      outbound_list = outbound.split(/\r\n/)
      outbound_list.each do |item|
        item = item.gsub(/\s+/, '')
        items = item.split(/[\\\/]/)
        if (items.size == 2)
          ot = Outbound.find_or_initialize_by_flight_no_and_arrival_flight_id(items[0].upcase, self.id)
          ot.update_attribute(:pax_number, items[1])
        end
      end
    end
  end
end

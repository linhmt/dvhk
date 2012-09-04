include ActionView::Helpers::SanitizeHelper

class ArrivalFlight < ActiveRecord::Base
  resourcify
  belongs_to :user
  belongs_to :routing
  has_many :outbounds, :dependent => :destroy
  validates :flight_no, :flight_date, :sta, :presence => true
  default_scope :order => 'sta asc'
  default_scope where(:is_active => true)
  attr_accessor :outbound_tags, :sta_arrnextday, :eta_arrnextday, :ata_arrnextday
  before_save :update_internal_attributes

  scope :assigned_flights, lambda { |user|
    where("(arrival_flights.user_id = ? or arrival_flights.lnf_user_id = ?) AND arrival_flights.flight_date = DATE(NOW())",
      user.id, user.id)
  }
  
  def self.arrival_flights(date, is_domestic, page)
    flight_date = ArrivalFlight.retrieve_flight_date(date)
    condition = {
      :flight_date => flight_date.midnight.utc..flight_date.end_of_day.utc
    }
    if is_domestic.nil?
      ArrivalFlight.where(condition).page(page).per(30)
    else
      ArrivalFlight.where(condition).where(:is_domestic => is_domestic.to_bool).page(page).per(30)
    end
  end

  def self.open_flights(date, user_id=nil, page)
    flight_date = ArrivalFlight.retrieve_flight_date(date)
    condition = {
      :is_approval => false,
      :flight_date => flight_date.midnight.utc..flight_date.end_of_day.utc
    }
    condition = condition.merge({:user_id => user_id}) unless user_id.nil?
    ArrivalFlight.where(condition).page(page).per(25)
  end

  def update_internal_attributes
    self.flight_no = self.flight_no.upcase
    self.is_domestic = update_is_domestic
    self.remarks = update_remarks if self.remarks_changed?
    self.sta = adjust_arrival_time(self.flight_date, self.sta, self.sta_arrnextday)
    self.eta = adjust_arrival_time(self.flight_date, self.eta, self.eta_arrnextday)
    self.ata = adjust_arrival_time(self.flight_date, self.ata, self.ata_arrnextday)
    true
  end

  def adjust_arrival_time(date_t, time_t, arrnextday)
    if (!time_t.nil?)
      if (!arrnextday.nil? && arrnextday == "1")
        time_temp = Time.new(date_t.year, date_t.month, date_t.day, time_t.hour, time_t.min)
        adjusted_time = time_temp.advance(:days => +1)
      else
        adjusted_time = Time.new(date_t.year, date_t.month, date_t.day, time_t.hour, time_t.min)
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

  def self.open_flight_dates
    ArrivalFlight.find_by_sql("SELECT flight_date, count(id) as c_id, user_id FROM arrival_flights
WHERE is_approval=false AND flight_date <= Date(NOW()) GROUP BY flight_date, user_id ORDER BY flight_date desc;")
  end

  def self.max_flight_number(flight_date)
    max = ArrivalFlight.where("flight_date = ? AND flight_no LIKE 'YY%'",flight_date).maximum(:flight_no)
    if max
      m_flight = max.slice(2..(max.length-1)).to_i
    else
      m_flight = 0
    end
    m_flight
  end

  def process_outbound_text(outbound_text)
    temp_list = outbound_text.gsub(/&nbsp|;|\s+|&yen/, '').split(/<br\s*\/>/)
    temp_list = temp_list.select{|e| e.match(/^[0-9]/)}
    outbound_hash = Hash.new
    temp_list.each do |ot_line|
      ot_line = strip_tags(ot_line)
#      begin
        flt_i = ArrivalFlight.parse_flight_outbound_line(ot_line)
        flt = flt_i[0..5]
        flt_pax = flt + '@' + flt_i[-5..-1] + '---' + ArrivalFlight.parse_name_outbound_line(ot_line)
        flt_pax <<  '....' + ot_line[ot_line.length-6, 6]
        if outbound_hash.has_key?(flt)
          outbound_hash[flt] += [flt_pax]
        else
          outbound_hash[flt] = [flt_pax]
        end
#      rescue => e
#        logger.error "Cannot parse: " + ot_line
#        #        logger.error e.message
#        #        e.backtrace.each { |line| logger.error line }
#      end
    end
    outbound_hash
  end

  def outbound_tags
    ots = self.outbounds
    unless ots.blank?
      list_items = '<ul>'
      ots.each { |ot|
        list_items += '<li>'+ ot.flight_no + '/' + ot.pax_number.to_s + '</li>'
      }
      list_items += '</ul>'
    else
      list_items = ''
    end
    list_items
  end

  def outbound_tags=(ob_tags)
    unless ob_tags.nil?
      if ob_tags.match(/<ul\>|<li\>/)
        puts ob_tags.inspect
        process_outbound_manual(ob_tags)
      else
        outbound_hash = process_outbound_text(ob_tags)
        update_flight_outbounds(outbound_hash)
      end
    end
  end

  private

  def update_remarks
    temp = self.remarks_was
    if temp.nil?
      temp = self.remarks
    else
      temp += " " + self.remarks unless self.remarks.nil?
    end
    temp
  end

  def process_outbound_manual(outbound_tags)
    outbound = strip_tags(outbound_tags)
    outbound_list = outbound.split(/\r\n/)
    Outbound.where(:arrival_flight_id => self.id).destroy_all
    outbound_list.each do |item|
      item = item.gsub(/\s+/, '')
      items = item.split(/[\\\/]/)
      if (items.size == 2)
        ot = Outbound.find_or_initialize_by_flight_no_and_arrival_flight_id(items[0].upcase, self.id)
        ot.update_attribute(:pax_number, items[1])
      end
    end
  end

  def self.parse_flight_outbound_line(outbound_line)
    str = outbound_line.slice!(/[0-9A-Z]{2}\.?\d{3,4}\.?SGN-[A-Z]{3}\.{,2}\d{3,4}(A|P|M)/)
    str
  end

  def self.parse_name_outbound_line(outbound_line)
    str = outbound_line.slice(/[A-Z]+[\/|A-Z|\s]+/)
    str
  end

  def update_flight_outbounds(outbound_hash = {})
    outbound_hash.each_pair { |key, value|
      ot = Outbound.find_or_initialize_by_flight_no_and_arrival_flight_id(key.gsub(/\./,'').upcase,self.id)
      ot.update_attributes({:pax_number => value.length, :details => value.join(',')})
    }
  end
end
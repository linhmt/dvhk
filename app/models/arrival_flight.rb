include ActionView::Helpers::SanitizeHelper

class ArrivalFlight < ActiveRecord::Base
  resourcify
  audited :allow_mass_assignment => true, :except => :outbound_tags
  belongs_to :user
  belongs_to :routing
  has_many :outbounds, :dependent => :destroy
  validates :flight_no, :flight_date, :presence => true
  default_scope :order => 'sta asc'
  default_scope where(:is_active => true)
  attr_accessor :outbound_tags, :sta_arrnextday, :eta_arrnextday, :ata_arrnextday
  before_save :update_internal_attributes
  before_update :set_sta_changed
  #  after_save :updating_outbounds
  
  def self.arrival_flights_all(date, is_domestic)
    flight_date = ArrivalFlight.retrieve_flight_date(date)
    condition = {
      :flight_date => flight_date.midnight.utc..flight_date.end_of_day.utc
    }
    if is_domestic.nil?
      ArrivalFlight.where(condition)
    else
      ArrivalFlight.where(condition).where(:is_domestic => is_domestic.to_bool)
    end
  end
  
  def self.arrival_flights(date, is_domestic, page)
    flight_date = ArrivalFlight.retrieve_flight_date(date)
    condition = {
      :sta => flight_date.midnight.utc..flight_date.end_of_day.utc.advance(:hours => 3)
    }
    if is_domestic.nil?
      ArrivalFlight.where(condition).page(page).per(200)
    else
      ArrivalFlight.where(condition).where(:is_domestic => is_domestic.to_bool).page(page).per(200)
    end
  end
  
  def self.assigned_flights(user, flight_date)
    ArrivalFlight.where(:flight_date => flight_date).where("user_id = #{user.id} OR lnf_user_id = #{user.id}")
  end
  
  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |flight|
        csv << flight.attributes.values_at(*column_names)
      end
    end
  end
  
  def self.arrival_codeshare(o_date = Date.today)
    if o_date.wday == 0
      wdate = 7
    else
      wdate = o_date.wday
    end
    codeshares = FlightType.where("is_codeshare is true and is_active is true and operating_day like '%#{wdate}%'")
    codeshares.each do |cs|
      arrival = ArrivalFlight.with_exclusive_scope {
        find_or_initialize_by_flight_no_and_flight_date(cs.flight_no_from, o_date)
      }
      local_time = cs.operating_time
      arrival.sta = Time.utc(o_date.year, o_date.month, o_date.day, local_time.hour, local_time.min)
      arrival.routing_id = cs.routing.id
      arrival.is_domestic = cs.routing.is_domestic
      arrival.is_active = true
      arrival.is_approval = false
      arrival.save!
    end
  end
  
  def self.search_flight(date, flight_no)
    flight_date = ArrivalFlight.retrieve_flight_date(date)
    condition = {
      :flight_date => flight_date.midnight.utc..flight_date.end_of_day.utc
    }
    ArrivalFlight.where(condition).where("flight_no LIKE :str", :str => "%" + flight_no + "%").page(nil)
  end
  
  def self.open_flights(date, user_id=nil, page)
    flight_date = ArrivalFlight.retrieve_flight_date(date)
    condition = {
      :is_approval => false,
      :flight_date => flight_date.midnight.utc..flight_date.end_of_day.utc
    }
    if user_id.nil?
      ArrivalFlight.where(condition).where("user_id is not NULL").page(page).per(25)
    else
      condition = condition.merge({:user_id => user_id})
      ArrivalFlight.where(condition).page(page).per(25)
    end
  end

  def set_sta_changed
    self.sta_changed = true unless self.sta_change.nil?
  end
  
  def update_internal_attributes
    self.flight_no = self.flight_no.upcase
    self.ssr = update_ssr if self.ssr_changed?
    self.sta = adjust_arrival_time(self.flight_date, self.sta, self.sta_arrnextday)
    self.eta = adjust_arrival_time(self.flight_date, self.eta, self.eta_arrnextday)
    self.ata = adjust_arrival_time(self.flight_date, self.ata, self.ata_arrnextday)
    true
  end
  
  def update_new_remark(n_content, updating_id)
    updating = Time.now.strftime("%d/%b %H:%M:%S")
    username = User.find(updating_id).short_name
    self.irregular_information.blank? ? old_info = "" : old_info = self.irregular_information
    self.irregular_information = "<b>" + updating + " - " + username + "</b><br/>" + n_content + "<br/>" + old_info
    self.save!
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
    if date.blank?
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

  def self.open_flight_dates(from_date = nil)
    if from_date.nil?
      ArrivalFlight.find_by_sql("SELECT flight_date, count(id) as c_id, user_id FROM arrival_flights
WHERE is_approval=false AND flight_date <= Date(NOW()) AND user_id IS NOT NULL
GROUP BY flight_date, user_id ORDER BY flight_date desc;")
    else
      ArrivalFlight.find_by_sql("SELECT flight_date, count(id) as c_id, user_id FROM arrival_flights
WHERE is_approval=false AND flight_date >= '#{from_date}' AND flight_date <= Date(NOW()) AND user_id IS NOT NULL
GROUP BY flight_date, user_id ORDER BY flight_date desc;")
    end
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
    temp_list = outbound_text.gsub(/&nbsp|;|\s+|&yen/, '').split(/<\/div><div>|<br\s*\/>/)
    temp_list = temp_list.select{|e| e.match(/^[0-9]/)}
    outbound_hash = Hash.new
    temp_list.each do |ot_line|
      ot_line = strip_tags(ot_line)
      begin
        flt_i = ArrivalFlight.parse_flight_outbound_line(ot_line)
        flt = flt_i[0..5]
        if outbound_hash.has_key?(flt)
          outbound_hash[flt] += [ot_line]
        else
          outbound_hash[flt] = [ot_line]
        end
      rescue => e
        logger.error "Cannot parse: " + ot_line
        logger.error e.message
        e.backtrace.each { |line| logger.error line }
      end
    end
    outbound_hash
  end

  def outbound_tags
    ots = self.outbounds
    if ots.blank?
      list_items = 'nil'
    elsif  (ots.size == 1 && ots.first.flight_no.nil?)
      list_items = ots.first.details
    else
      list_items = "<ul class=\"outbounds\">"
      ots.each { |ot|
        list_items += '<li>'+ ot.flight_no + '/' + ot.pax_number.to_s + '</li>'
      }
      list_items += '</ul>'
    end
    list_items
  end

  def outbound_tags=(ob_tags)
    unless ob_tags.nil?
      if ob_tags.match(/<ul\>|<li\>/)
        return
        #        process_outbound_manual(ob_tags)
      elsif ob_tags.length <= 10
        Outbound.where(:arrival_flight_id => self.id).delete_all
        ot = Outbound.new(:arrival_flight_id => self.id, :details => ob_tags)
        ot.save!
      else
        Outbound.where(:arrival_flight_id => self.id).delete_all
        outbound_hash = process_outbound_text(ob_tags)
        update_flight_outbounds(outbound_hash)
      end
    end
  end

  private

  def update_ssr
    temp = self.ssr.gsub(/&nbsp|;|\s{2,}|&yen|<div>/, '')
    temp = temp.gsub(/<\/div>/, '<br/>')
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
    str = outbound_line.slice(/[0-9A-Z]{2}\.*\d{1,4}\.?[A-Z]{3}-[A-Z]{3}\.{,2}\d{3,4}[A|P|M|N]/)
    str
  end

  def self.parse_name_outbound_line(outbound_line)
    str = outbound_line.slice(/([0-9]{2}[A-Z]+[\/|A-Z|\s]+[.]+)([A-Z0-9]{2,}\/[A-Z0-9]{2,}\.[A-Z]{1}|[A-Z])/)
    str
  end

  def update_flight_outbounds(outbound_hash = {})
    outbound_hash.each_pair { |key, value|
      ot = Outbound.find_or_initialize_by_flight_no_and_arrival_flight_id(key.gsub(/\./,'').upcase,self.id)
      std = value.first.slice(-13,5)
      ot.update_attributes({:std => std, :pax_number => value.length, :details => value.join(',')})
    }
  end
end
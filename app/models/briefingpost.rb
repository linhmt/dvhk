class Briefingpost < ActiveRecord::Base
  audited :allow_mass_assignment => true, :protect => false
  attr_accessible :content, :active_date, :is_domestic, :is_departure, :active_shift, :is_completed, :is_active, :active_flight
  belongs_to :user
  validates :content, :presence => true
  validates_length_of :content, :within => 10..5000
  validates :user_id, :presence => true
  validates :active_date, :presence => true
  default_scope :order => 'active_shift asc, active_flight asc, is_departure asc, is_domestic desc, created_at desc'

  before_save :add_timestamp_to_active_date

  def self.briefing_posts_count(date)
    active_date = Briefingpost.retrieve_active_date(date)
    condition = {:active_date => active_date.midnight.utc..active_date.end_of_day.utc}
    Briefingpost.where(condition).count
  end

  def self.briefing_posts(date, shift, page)
    active_date = Briefingpost.retrieve_active_date(date)
    if shift.nil?
      condition = {
        :active_date => active_date.midnight.utc..active_date.end_of_day.utc
      }
    else
      condition = {
        :active_date => active_date.midnight.utc..active_date.end_of_day.utc,
        :active_shift => shift
      }
    end
    Briefingpost.where(condition).page(page)
  end

  def self.area_briefing_posts(date, area, page)
    active_date = Briefingpost.retrieve_active_date(date)
    condition = {
      :is_active => true,
      :active_date => active_date.midnight.utc..active_date.end_of_day.utc,
      :is_departure => area.to_bool
    }
    Briefingpost.where(condition).page(page)
  end
  
  protected
  def add_timestamp_to_active_date
    self.active_date = active_date.to_time
    self.active_flight = active_flight.upcase
  end

  def self.retrieve_active_date(date)
    Time.zone=('Hanoi')
    if date.nil?
      date = DateTime.now.to_date.to_s
    end
    a_date = Time.zone.parse(date)
    a_date
  end
end

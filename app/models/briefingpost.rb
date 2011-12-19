class Briefingpost < ActiveRecord::Base
  attr_accessible :content, :active_date, :is_domestic, :is_departure, :active_shift, :is_completed
  belongs_to :user
  validates :content, :presence => true, :length => { :maximum => 250 }
  validates :user_id, :presence => true
  validates :active_date, :presence => true
  default_scope :order => 'briefingposts.active_date DESC,
briefingposts.active_shift asc, 
briefingposts.is_departure asc,
  briefingposts.is_domestic asc'
  
  before_save :add_timestamp_to_active_date
  
  protected
  def add_timestamp_to_active_date
    self.active_date = active_date.to_time
  end
end

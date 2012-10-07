class Notice < ActiveRecord::Base
#  acts_as_audited :associated_with => :user
  validates :content, :presence => true
  belongs_to :user
  attr_accessible :content, :is_active 
  default_scope :order => "is_active desc, created_at desc"
  
  def self.active_important_notices
    notices_count = Notice.where(:is_active => true).count
    notices_count
  end
end

class Notice < ActiveRecord::Base
  acts_as_audited :associated_with => :user
  validates :content, :presence => true
  belongs_to :user
  attr_accessible :content, :is_active 
  default_scope :order => "created_at desc"
end

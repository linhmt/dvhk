class User < ActiveRecord::Base
	rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable,
  devise :database_authenticatable, :recoverable, :trackable, :validatable, :timeoutable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :name, :short_name
  validates :name, :presence => true
  validates_uniqueness_of :name, :email, :case_sensitive => false
  has_many :passengers
  has_many :flights
  has_many :arrival_flights
  has_many :briefingposts, :dependent => :destroy
  has_many :notices
  has_many :user_role_mappings, :dependent => :destroy
  has_many :user_roles, :through => :user_role_mappings
  has_associated_audits
  
  def can_delete_briefing
    self.user_roles.where(:short_desc => "delete_briefing").count == 1
  end
  
  def disapproval_arrival_flights(arrival_flights, comment)
    arrival_flights.each do |a_flight|
      a_flight.notify_count.nil? ? a_flight.notify_count = 1 : a_flight.notify_count += 1
      a_flight.notify_message = comment
      a_flight.notify_by = self.id
      if a_flight.remarks
        a_flight.remarks += comment
      else
        a_flight.remarks = comment
      end
      a_flight.save!
    end
    UserMailer.disapproval_arrival_flights(arrival_flights, comment).deliver
  end
end

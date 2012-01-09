class Flight < ActiveRecord::Base
  belongs_to :user;
  belongs_to :routing;
end

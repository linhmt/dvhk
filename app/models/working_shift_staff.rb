class WorkingShiftStaff < ActiveRecord::Base
  default_scope order('duty_date desc')
end

class ShiftTracking < ActiveRecord::Base
  serialize :working_duties, Hash
  attr_accessor :daily_time

  def generate_attr_accessors
    (1..31).each do |day|
      self.class.__send__(:attr_accessor, "ot_#{day}")
      self.__send__("ot_#{day}=", self.working_duties["d_#{day}".to_sym][2])
    end
  end

  def self.invalid_hour(ps, s_hour)
    valid_ps = SystemConstant.find_by_name("valid_position").value
    hour = 0.0
    hour = s_hour.to_f if (!valid_ps.include?(ps) && s_hour.to_f < 0)
    hour
  end

  def self.allowed_negative_hour(ps, s_hour)
    valid_ps = SystemConstant.find_by_name("valid_position").value
    hour = 0.0
    hour = s_hour.to_f if (valid_ps.include?(ps) && s_hour.to_f < 0)
    hour
  end

  def self.staff_day_off_record(row)
    st = ShiftTracking.find_or_initialize_by_staff_id(row[0].to_i)
    st.ot_day_begin = row[3].to_f
    st.annual_day_begin = row[4].to_f
    st.save!
  end

  # Each staff has 4 rows
  def self.add_staff_record(rows, standard_day_off)
    st = ShiftTracking.find_or_initialize_by_staff_id(rows[0][0].to_i, :fullname => rows[0][1])
    st.standard_day_off = standard_day_off
    st.weekend = 0
    st.holiday = 0
    st.ot_time = 0
    st.invalid_hour = 0.0
    st.allowed_negative = 0.0
    st.annual_day_used = 0
    st.ot_day_used = 0
    st.working_duties = Hash.new
    (1..31).each do |date|
      key = "d_" + date.to_s
      st.working_duties = st.working_duties.merge(key.to_sym => [
          rows[1][date+2].to_s,
          rows[2][date+2].to_s,
          rows[3][date+2].to_s])
      st.weekend = st.weekend + 1 if rows[1][date+2] == "-"
      st.holiday = st.holiday + 1 if rows[1][date+2] == "L"
      st.annual_day_used = st.annual_day_used + 1 if rows[1][date+2] == "P"
      st.ot_day_used = st.ot_day_used + 1 if rows[1][date+2] == "NB"
      st.invalid_hour = st.invalid_hour.to_f + ShiftTracking.invalid_hour(
        rows[2][date+2].to_s,
        rows[3][date+2].to_s)
      st.allowed_negative = st.allowed_negative.to_f + ShiftTracking.allowed_negative_hour(
        rows[2][date+2].to_s,
        rows[3][date+2].to_s
      )
      st.ot_time = st.ot_time.to_f + rows[3][date+2].to_f if rows[3][date+2].to_f > 0
    end
    st.calculate_month_overtime
    st.save!
  end

  def calculate_month_overtime
    self.ot_time = self.ot_time + self.allowed_negative
    self.ot_time = self.ot_time + (self.standard_day_off - (self.holiday + self.weekend))*8
    self.ot_time = self.ot_time - self.ot_day_used * 8
  end

  def calculate_unused_annual_leave
    self.annual_day_begin.to_f - self.annual_day_used.to_f
  end
  
  def calculate_unused_ot_day
    begin
      self.ot_day_begin + (self.ot_time / 8)
    rescue Exception
      (self.ot_time / 8)
    end
  end
end

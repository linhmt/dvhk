class ShiftTracking < ActiveRecord::Base
  serialize :working_duties, Hash
  
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
  
  # Each staff has 4 rows
  def self.add_staff_record(rows)
    st = ShiftTracking.new(
      :weekend => 0,
      :holiday => 0,
      :ot_time => 0,
      :invalid_hour => 0.0,
      :allowed_negative => 0.0)
    st.staff_id = rows[0][0].to_i
    st.working_duties = Hash.new
    (1..31).each do |date|
      key = "day_" + date.to_s
      st.working_duties = st.working_duties.merge(key.to_sym => [
          rows[1][date+2].to_s,
          rows[2][date+2].to_s,
          rows[3][date+2].to_s])
      st.weekend = st.weekend + 1 if rows[1][date+2] == "-"
      st.holiday = st.holiday + 1 if rows[1][date+2] == "L"
      st.invalid_hour = st.invalid_hour.to_f + ShiftTracking.invalid_hour(
        rows[2][date+2].to_s,
        rows[3][date+2].to_s)
      st.allowed_negative = st.allowed_negative.to_f + ShiftTracking.allowed_negative_hour(
        rows[2][date+2].to_s,
        rows[3][date+2].to_s
      )
      st.ot_time = st.ot_time.to_f + rows[3][date+2].to_f if rows[3][date+2].to_f > 0
    end
    st.save!
  end
end

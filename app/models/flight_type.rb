class FlightType < ActiveRecord::Base
  belongs_to :routing
  
  def self.insert_codeshare(flt_no, operator, oper_time, routing, oper_date = "1234567")
    ft = self.find_or_initialize_by_flight_no_from(flt_no)
    rt = Routing.where(:routing => routing).first
    ft.flight_no_from = flt_no
    ft.flight_no_to = flt_no
    ft.is_active = true
    ft.is_arrival = true
    ft.is_codeshare = true
    ft.is_domestic = rt.is_domestic
    ft.operator = operator
    ft.operating_time = oper_time
    ft.operating_day = oper_date
    ft.routing_id = rt.id
    ft.save!
  end
  
  def self.insert_codeshare_data
    list = {
      'VN3503' => ['CZ', Time.local(2012,10,28,14,10), 'CAN-SGN', "1234567"],
      'VN3818' => ['K6', Time.local(2012,10,28,11,50), 'REP-SGN', "1234567"],
      'VN3854' => ['K6', Time.local(2012,10,28,17,25), 'PNH-SGN', "1234567"],
      'VN3820' => ['K6', Time.local(2012,10,28,18,45), 'REP-SGN', "1234567"],
      'VN3822' => ['K6', Time.local(2012,10,28,22,45), 'REP-SGN', "1234567"],
      'VN8060' => ['0V', Time.local(2012,10,28,8,40), 'CAH-SGN', "1234567"],
      'VN8052' => ['0V', Time.local(2012,10,28,15,25), 'VCS-SGN', "134567"],
      'VN8054' => ['0V', Time.local(2012,10,28,13,50), 'VCS-SGN', "1234567"],
      'VN8431' => ['0V', Time.local(2012,10,28,13,25), 'VCL-SGN', "13567"],
      'VN8443' => ['0V', Time.local(2012,10,28,17,40), 'VCL-SGN', "13567"]
    }
    list.each do |key, value|
        FlightType.insert_codeshare(key, value[0], value[1], value[2], value[3])
    end
  end
end
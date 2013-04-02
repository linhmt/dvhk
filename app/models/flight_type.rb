class FlightType < ActiveRecord::Base
  belongs_to :routing
  default_scope where(:is_active => true)
  
  def self.insert_codeshare(flt_no, operator, oper_time, routing, oper_date = "1234567")
    ft = self.find_or_initialize_by_flight_no_from_and_operating_day(flt_no, oper_date)
    rt = Routing.find_by_routing.last
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
  
  def self.update_codeshare(vn_flight, oa_flight, o_day, o_time_local, routing = nil)
    flight = FlightType.find_by_flight_no_from_and_flight_no_to(vn_flight,oa_flight)    
    if flight.nil?
      FlightType.update_all(
                            {:is_active => false},
        "flight_no_from = '#{vn_flight}' OR flight_no_to = '#{oa_flight}'")
      flight = FlightType.new
      flight.flight_no_from = vn_flight
      flight.flight_no_to = oa_flight
    end
    flight.routing = Routing.find_by_routing(routing)
    flight.is_codeshare = true
    flight.is_active = true
    flight.operator = oa_flight.slice(0,2)
    flight.operating_day = o_day
    flight.operating_time = o_time_local.utc
    flight.save!
  end
  
  def self.insert_codeshare_data
    list = {
      'VN3563' => ['CX767', Time.local(2013,03,31,10,20), 'HKG-SGN', "1234567"],
      'VN3561' => ['CX765', Time.local(2013,03,31,17,55), 'HKG-SGN', "1234567"],
      'VN2691' => ['PR591', Time.local(2013,03,31, 8,30), 'MNL-SGN', "12346"],
      'VN2693' => ['PR597', Time.local(2013,03,31,14,30), 'MNL-SGN', "57"],
      'VN3403' => ['KE681', Time.local(2013,03,31,11,40), 'ICN-SGN', "1234567"],
      'VN3401' => ['KE683', Time.local(2013,03,31,22,05), 'ICN-SGN', "1234567"],
      'VN3503' => ['CZ373', Time.local(2013,03,31,14,25), 'CAN-SGN', "1234567"],
      'VN3501' => ['CZ367', Time.local(2013,03,31,23,10), 'CAN-SGN', "1234567"],
      'VN3307' => ['JL759', Time.local(2013,03,31,22,20), 'NRT-SGN', "1234567"],
      'VN3525' => ['MU789', Time.local(2013,03,31,22,50), 'PVG-SGN', "1234567"],
      'VN3523' => ['MU281', Time.local(2013,04,01,00,55), 'PVG-SGN', "1234567"],
      'VN2106' => ['AF258', Time.local(2013,03,31,06,55), 'CDG-SGN', "2357"],
      
      'VN3818' => ['K6808', Time.local(2013,03,31,12,40), 'REP-SGN', "1234567"],
      'VN3850' => ['K6816', Time.local(2013,03,31,11,00), 'PNH-SGN', "1357"],
      'VN3856' => ['K6818', Time.local(2013,03,31,20,10), 'PNH-SGN', "1234567"],
      'VN3824' => ['K6824', Time.local(2013,03,31,14,40), 'REP-SGN', "1234567"],      
      'VN3822' => ['K6822', Time.local(2012,10,28,22,45), 'REP-SGN', "1234567"],
      
      'VN8060' => ['0V8060', Time.local(2013,03,31,8,40), 'CAH-SGN', "1234567"],
      'VN8050' => ['0V8050', Time.local(2013,03,31,8,40), 'VCS-SGN', "1234567"],
      'VN8052' => ['0V8052', Time.local(2013,03,31,12,15), 'VCS-SGN', "1246"],
      'VN8052' => ['0V8052', Time.local(2013,03,31,15,25), 'VCS-SGN', "357"],
      'VN8054' => ['0V8054', Time.local(2013,03,31,14,10), 'VCS-SGN', "1234567"],
      'VN8056' => ['0V8056', Time.local(2013,03,31,17,45), 'VCS-SGN', "57"],
      'VN8072' => ['0V8072', Time.local(2013,03,31,16,50), 'VCS-SGN', "1234567"],
      'VN8431' => ['0V8431', Time.local(2013,03,31,13,25), 'VCL-SGN', "13567"],
      'VN8443' => ['0V8443', Time.local(2013,03,31,18,00), 'TBB-SGN', "1234567"]
    }
    
    list.each do |key, value|
      #    update_codeshare(vn_flight, oa_flight, o_day, o_time_local, routing = nil)
      FlightType.update_codeshare(key, value[0], value[3], value[1], value[2])
    end
  end
end
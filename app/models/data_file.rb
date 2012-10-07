class DataFile < ActiveRecord::Base
  has_attached_file :dailyroster,
    :styles => { :medium => "300x300>", :thumb => "100x100>" },
    :path => ":rails_root/public/system/:attachment/:active_date/:basename.:extension"
  before_post_process :image?
  after_save :load_data

  Paperclip.interpolates :active_date do |attachment, style|
    attachment.instance.active_date.to_date.to_formatted_s(:number)
  end

  def image?
    !(dailyroster_content_type =~ /^image.*/).nil?
  end


  def self.save(upload)
    name =  upload['datafile'].original_filename
    directory = "public/data"
    # create the file path
    path = File.join(directory, name)
    # write the file
    File.open(path, "wb") { |f| f.write(upload['datafile'].read) }
  end

  private
  def load_data
    if self.is_arrival
      read_arrival(self.dailyroster_file_name)
    else
      read_departure(self.dailyroster_file_name)
    end
  end

  # Start from 1 because split creates empty string
  def read_departure(upload)
    active_date = self.active_date.to_date
    path = File.join("public/system/dailyrosters/#{active_date.to_formatted_s(:number)}", upload)
    flight_date = active_date
    File.open(path, 'r') {|f|
      lines = f.readlines("\n")
      lines.each do |line|
        a = line.split(%r{[|\s]+})
        if (a.length > 5 && a[3].match(/VN.*/))
          route_s = a[4].split('-')
          route = Routing.find_or_create_by_routing(a[4], {:is_arrival => false, :destination => route_s[1]})
          if (route.destination != "Sai Gon")
            aircraft = get_aircraft(a[2])
            time_raw = a[5].split(':')
            std_time = Time.local(
              flight_date.year,
              flight_date.month,
              flight_date.day,
              time_raw[0],
              time_raw[1]
            )
            begin
              flight = Flight.new
              flight.flight_no = a[3]
              flight.routing_id = route.id
              flight.aircraft_id = aircraft.id
              flight.flight_date = flight_date
              flight.std = std_time
              flight.remark = a[6]
              flight.save!
            rescue ActiveRecord::RecordNotSaved => e
              flight.errors.full_messages
            end
          end
        end
      end
    }
    path
  end
  
  # Start from 1 because split creates empty string
  def read_arrival(upload)
    active_date = self.active_date.to_date
    path = File.join("public/system/dailyrosters/#{active_date.to_formatted_s(:number)}", upload)
    File.open(path, 'r') {|f|
      lines = f.readlines("\n")
      lines.each do |line|
        a = line.split(%r{[|\s]+})
        if (a.length > 5 && a[3].match(/VN.*/))
          route = Routing.find_or_create_by_routing(a[4], {:is_arrival => true, :destination => "Sai Gon"})
          if (route.destination == "Sai Gon")
            aircraft = get_aircraft(a[2])
            time_raw = a[5].split(':')
            if (!a[6].nil? && a[6] == 'ARRNEXTDAY')
              flight_date = active_date.advance(:days => 1)
              sta_time = Time.local(flight_date.year, flight_date.month, flight_date.day, time_raw[0], time_raw[1])
            else
              sta_time = Time.local(active_date.year, active_date.month, active_date.day, time_raw[0], time_raw[1])
              flight_date = active_date
            end
            flight = ArrivalFlight.find_or_initialize_by_flight_no_and_flight_date(a[3], flight_date)
#            flight.flight_no = flight_no(a[3], route, flight_date)
            if a[3] == "VN"
              flight.flight_no = 'YY' + (ArrivalFlight.max_flight_number(flight_date) + 1).to_s
              flight.remarks = "Pls check flight no."
            else
              flight.flight_no = a[3]
              flight.remarks = a[6] if !a[6].blank?
            end
            flight.routing_id = route.id
            flight.reg_no = aircraft.reg_no
            flight.flight_date = flight_date
            flight.is_domestic = flight.update_is_domestic
            flight.sta = sta_time
            flight.is_active = true
            flight.is_approval = false
            begin
              flight.save!
            rescue ActiveRecord::StatementInvalid => e
              if flight.flight_no == "VN"
                flight.flight_no = 'YY' + (ArrivalFlight.max_flight_number(flight_date) + 1)
                flight.remarks += "Pls check flight no."
                flight.save!
              end
            rescue ActiveRecord::RecordNotSaved => e
              flight.errors.full_messages
            end
          end
        end
      end
    }
    update_codeshare_flights(active_date, true)
    path
  end
  
#  def flight_no(flight_no_raw, route, flight_date)
#    irb(main):002:0> r.routing
#=> "PXU-HAN-PXU-SGN"
#irb(main):003:0> a = r.routing.split(/-/)
#=> ["PXU", "HAN", "PXU", "SGN"]
#irb(main):004:0> a[a.length-2]
#=> "PXU"
#irb(main):005:0> r1 = Routing.find_by_routing(a.last+"-"+a[a.length-2])
#  Routing Load (0.0ms)  SELECT `routings`.* FROM `routings` WHERE `routings`.`routing` = 'SGN-PXU' LIMIT 1
#=> #<Routing id: 5, routing: "SGN-PXU", destination: "Pleiku", is_domestic: true, include_transit: false, transit_point: "", created_at: "2012-01-11 12:40:
#40", updated_at: "2012-01-11 12:40:40", is_arrival: nil>
#irb(main):006:0> r1 = Routing.find_by_routing(a.last+"-"+a[a.length-2]).is_domestic
#  Routing Load (0.0ms)  SELECT #`routings`.* FROM `routings` WHERE `routings`.`routing` = 'SGN-PXU' LIMIT 1
#=> true
#irb(main):007:0>
#    temp = ""
#    if flight_no_raw == "VN"
#      routing = route.routing
#      dest = routing
#      
#      
#      temp = 'YY' + (ArrivalFlight.max_flight_number(flight_date) + 1).to_s
#    else
#      temp = flight_no_raw
#    end
#    temp
#  end
  
  def get_aircraft(aircraft_str)
    aircraft_d = aircraft_str.split('-')
    if (aircraft_d.size == 2)
      reg_no = aircraft_d[1]
      air_type = aircraft_d[0]
    elsif (aircraft_d.size == 3)
      reg_no = aircraft_d[2]
      air_type = aircraft_d[1]
    else
      reg_no = '999'
      air_type = aircraft_d[0]
    end
    Aircraft.find_or_create_by_reg_no(reg_no, {:aircraft_type => air_type})
  end
  
  def update_codeshare_flights(active_date, is_arrival = false)
    
  end
end
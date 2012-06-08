class DataFile < ActiveRecord::Base
  def self.save(upload)
    name =  upload['datafile'].original_filename
    directory = "public/data"
    # create the file path
    path = File.join(directory, name)
    # write the file
    File.open(path, "wb") { |f| f.write(upload['datafile'].read) }
  end


  # Start from 1 because split creates empty string
  def self.read_arrival(upload)
    path = File.join("public/data", upload)
    flight_date = Date.parse(upload.slice(0..7))
    File.open(path, 'r') {|f|
      lines = f.readlines("\n")
      lines.each do |line|
        a = line.split(%r{[|\s]+})
        if (a.length > 5 && a[3].match(/VN.*/))
          route = Routing.find_or_create_by_routing(a[4], {:is_arrival => true, :destination => "Sai Gon"})
          aircraft_d = a[2].split('-')
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
          time_raw = a[5].split(':')
          if (!a[6].nil? && a[6] == 'ARRNEXTDAY')
            sta_time = Time.local(flight_date.year, flight_date.month, flight_date.day + 1, time_raw[0], time_raw[1])
            flight_date = flight_date.advance(:days => 1)
          else
            sta_time = Time.local(flight_date.year, flight_date.month, flight_date.day, time_raw[0], time_raw[1])
          end
          begin
            flight = ArrivalFlight.new
            flight.flight_no = a[3]
            flight.routing_id = route.id
            flight.reg_no = reg_no
            flight.flight_date = flight_date
            flight.sta = sta_time
            flight.remarks = a[6]
            flight.save!
          rescue ActiveRecord::RecordNotSaved => e
            flight.errors.full_messages
          end
        end
      end
    }
    path
  end
end

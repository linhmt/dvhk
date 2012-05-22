class DataFile < ActiveRecord::Base
  def self.save(upload)
    name =  upload['datafile'].original_filename
    directory = "public/data"
    # create the file path
    path = File.join(directory, name)
    # write the file
    File.open(path, "wb") { |f| f.write(upload['datafile'].read) }
  end
  
  def self.read(upload)
    path = File.join("public/data", upload)
    File.open(path, 'r') {|f|
      lines = f.readlines("\n")
      lines.each do |line|
        a = line.split(%r{[|\s]+})
        if (a.length > 5 && a[3].match(/VN.*/))
          route = Routing.find_by_routing a[4]
          if route.nil?
            route = Routing.new
            route.routing = a[4]
            route.is_arrival = true
            route.destination = "Sai Gon"
            route.save!
          end
          flight = ArrivalFlight.new
          aircraft_d = a[2].split('-')
          aircraft = Aircraft.find_by_reg_no(aircraft_d[1])
          if (aircraft.nil?)
            aircraft = Aircraft.new
            aircraft.aircraft_type = aircraft_d[0]
            aircraft.reg_no = aircraft_d[1]
            aircraft.save
          end
          flight.reg_no = aircraft_d[1]
          flight.flight_no = a[3]
          flight.flight_date = Date.today
          flight.routing_id = route.id
          flight.save!
        end
      end
    }
  end
end

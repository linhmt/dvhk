require 'spreadsheet'

class DataFile < ActiveRecord::Base
  has_attached_file :dailyroster,
    :styles => { :medium => "300x300>", :thumb => "100x100>" },
    :path => ":rails_root/public/system/:attachment/:active_date/:basename.:extension"
  before_post_process :image?
  after_save :read_data_file

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

  def self.convert_codeshare_flight_no
    sql = "UPDATE arrival_flights INNER JOIN flight_types ON flight_types.flight_no_to = arrival_flights.flight_no SET arrival_flights.flight_no = flight_types.flight_no_from WHERE arrival_flights.is_active = 1 AND (flight_no NOT like 'VN%')"
    ActiveRecord::Base.connection.execute(sql)
  end
  # Each staff has 4 rows
  # Row0 staff_id 0
  # Row1, Row2, Row 3: working days day 1 from index 3
  def self.shift_tracking_file
    Spreadsheet.open("C:/hk.xls", 'r') do |book|
      sheet = book.worksheet "MonthReport"
      (11..sheet.row_count).step(4) do |i|
        rows = [sheet.row(i),sheet.row(i+1),sheet.row(i+2),sheet.row(i+3)]
        ShiftTracking.add_staff_record(rows) unless (rows[0][0].blank?)
      end
    end
  end
  
  private
  # 177         - 0
  # AT7-231     - 1
  # K6809       - 2
  # SGN-REP     - 3
  # Time STD    - 4
  # Time ATD    - 5
  def read_data_file()
    active_date = self.active_date.to_date
    path = File.join("public/system/dailyrosters/#{active_date.to_formatted_s(:number)}", self.dailyroster_file_name)
    flight_date = active_date
    Spreadsheet.open(path, 'r') do |book|
      sheet = book.worksheet 0
      (7..sheet.row_count).each do |i|
        if (!sheet.row(i)[0].nil?)
          aircraft = get_aircraft(sheet.row(i)[1].to_s)
          flight_no = sheet.row(i)[2]
          routing_raw = sheet.row(i)[3].strip
          route = Routing.find_or_create_by_routing(routing_raw)
          if (sheet.row(i)[3].slice(0,3) == "SGN")
            flight = Flight.unscoped.find_or_initialize_by_flight_no_and_flight_date(flight_no, flight_date)
            flight.flight_no = flight_no
            flight.routing_id = route.id
            flight.aircraft_id = aircraft.id
            flight.flight_date = calculate_flight_date(flight_date,sheet.row(i))
            flight.std = calculate_flight_time(flight_date, sheet.row(i))
            flight.remark = sheet.row(i)[9] unless sheet.row(i)[9].nil?
            flight.save!
          else
            if calculate_flight_date(flight_date,sheet.row(i)) > flight_date
              flight = ArrivalFlight.new(:flight_no => flight_no)
            else
              flight = ArrivalFlight.unscoped.find_or_initialize_by_flight_no_and_flight_date(flight_no, flight_date)
            end
            flight.routing_id = route.id
            flight.reg_no = aircraft.reg_no
            flight.flight_date = calculate_flight_date(flight_date,sheet.row(i))
            flight.sta = calculate_flight_time(flight_date, sheet.row(i))
            flight.is_domestic = flight.update_is_domestic
            flight.is_active = true
            flight.is_approval = false
            flight.save!
          end
        end
      end
    end
    DataFile.convert_codeshare_flight_no
    path
  end
   
  def get_time_raw(row)
    if !row[4].blank?
      time_r = row[4]
    elsif !row[5].blank?
      time_r = row[5]
    else
      time_r = DateTime.now
    end
    time_r
  end
  
  def calculate_flight_date(flight_date, row)
    time_r = get_time_raw(row)
    f_date = flight_date
    if time_r.class.name == "String"
      time_raw = time_r.split(':')
      f_date = f_date.advance(:days => 1) if time_raw[1].match(/\d{2}\+/)
    end
    f_date
  end
  
  def calculate_flight_time(flight_date, row)
    time_r = get_time_raw(row)
    d_flight = calculate_flight_date(flight_date, row)
    if time_r.class.name == "DateTime"
      time_flt = Time.local(
        d_flight.year,
        d_flight.month,
        d_flight.day,
        time_r.hour,
        time_r.min)
    else
      time_raw = time_r.split(':')
      time_flt = Time.local(
        d_flight.year,
        d_flight.month,
        d_flight.day,
        time_raw[0],
        time_raw[1].slice(0,2))
    end
    time_flt
  end
  # Start from 1 because split creates empty string
  def read_arrival(upload)
    active_date = self.active_date.to_date
    ArrivalFlight.arrival_codeshare(active_date)
    ArrivalFlight.arrival_codeshare(active_date.tomorrow)
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
    path
  end

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
end
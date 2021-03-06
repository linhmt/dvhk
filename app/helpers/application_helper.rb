module ApplicationHelper
  def current_important_notice
    imp_notice = Notice.where(:is_active => true).first
    if imp_notice.nil?
      notice = "Check out!!!"
    else
      notice = imp_notice.content
    end
    notice
  end
  
  def arrival_staff(p_date)
    begin
      if p_date.blank?
        roster = WorkingShiftStaff.where(:duty_date => Date.today).last.roster
      else
        roster = WorkingShiftStaff.where(:duty_date => p_date).last.roster
      end
    rescue
      roster = "No one assigned yet!"
    end
    roster
  end
  
  def assigned_flights
    flights = []
    if current_user
      flights = current_user.arrival_flights.where(:flight_date => Date.today) 
    end
    flights
  end
  
  def img_link_tag(name, icon, options={})
    icon_path = '/assets/web-app-theme/icons/'
    icon_path += icon
    img = tag("img", :src => icon_path,
      :alt =>"", :open => false)
    img << ' ' + name
    options.merge!(:href => 'root') unless options[:href]
    content_tag(:a, img, options)
  end
  
  def aircraft_type_reg_no(arrival_flight)
    air = Aircraft.find_by_reg_no(arrival_flight.reg_no)
    str = ""
    air.nil? ? str = arrival_flight.reg_no : str = air.aircraft_type + "-" + arrival_flight.reg_no
    str
  end
  
  def aircraft_type_reg_no_from_id(flight)
    air = Aircraft.find(flight.aircraft_id)
    str = ""
    air.nil? ? str = "N/A" : str = air.aircraft_type + "-" + air.reg_no
    str
  end
  
  def retrieve_all_outbounds(arrival_flight)
    ots = arrival_flight.outbounds
    unless ots.blank?
      list_items = ''
      ots.each { |ot|
        list_items << content_tag(:li, "#{ot.flight_no}/#{ot.pax_number}")
      }
      content_tag :ul, list_items.html_safe, :class => "outbounds"
    else
      ""
    end
  end
  
  def assign_roster_items
    list_items = ''
    list_items << content_tag(:li) { link_to "Upload Schedule", new_data_file_path }
    list_items << content_tag(:li) { link_to "Daily Arrival Roster", working_shift_staffs_path }
  end
end
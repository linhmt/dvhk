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
  
  def assigned_flights
    flights = current_user.arrival_flights.where(:flight_date => Date.today)
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
end

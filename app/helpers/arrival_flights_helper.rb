module ArrivalFlightsHelper
  def first_words(s, n)
    a = s.split(/\s|&nbsp;|\r\n/) # or /[ ]+/ to only split on spaces
    a[0...n].join(' ') + (a.size > n ? '...' : '')
  end
  
  def generate_further_information(arrival)
    f_info = ""
    f_info = f_info + "OB| " if (arrival.outbounds.size > 0)
    f_info = f_info + "BG| " unless (arrival.baggage.blank?)
    f_info = f_info + "Irregular| " unless (arrival.irregular_information.blank?)
    if (arrival.irregular_information.blank? && !arrival.remarks.blank?)
      f_info = f_info + "Remarks| "
    end
    if ((arrival.eta && (arrival.eta > arrival.sta)) || (arrival.ata && (arrival.ata > arrival.sta)))
      f_info = f_info + "DLY| "
    end
    f_info = f_info + "Aprroved| " if arrival.is_approval
    f_info = f_info + "Correction| " if (arrival.notify_count && arrival.notify_count > 0)
    f_info
  end
  
  def generate_further_information_staff(arrival)
    f_info = ""
    f_info = f_info + "Irregular| " unless (arrival.irregular_information.blank?)
    if ((arrival.eta && (arrival.eta > arrival.sta)) || (arrival.ata && (arrival.ata > arrival.sta)))
      f_info = f_info + "DLY| "
    end
    f_info = f_info + "Aprroved| " if arrival.is_approval
    f_info = f_info + "Correction| " if (arrival.notify_count && arrival.notify_count > 0)
    f_info = f_info + first_words(strip_tags(arrival.remarks), 5) unless (arrival.remarks.blank?)
    f_info
  end
  
  def display_aviation_time(time_raw, standard_date)
    if time_raw.blank?
      time_str = '...'
    elsif time_raw.localtime >= standard_date.end_of_day
      time_str = time_raw.to_formatted_s(:time) + "+1"
    else
      time_str = time_raw.to_formatted_s(:time)
    end
    time_str
  end
end

module ArrivalFlightsHelper
  def first_words(s, n)
    a = s.split(/\s/) # or /[ ]+/ to only split on spaces
    a[0...n].join(' ') + (a.size > n ? '...' : '')
  end
  
  def generate_further_information(arrival)
    f_info = ""
    if (user_signed_in?)
      f_info = f_info + "OT| " if (arrival.outbounds.size > 0)
      f_info = f_info + "BG| " unless (arrival.baggage.blank?)
    end
    f_info = f_info + "Irregular| " unless (arrival.irregular_information.blank?)
    if (arrival.irregular_information.blank? && !arrival.remarks.blank?)
      f_info = f_info + "Remarks| "
    end
    if ((arrival.eta && (arrival.eta > arrival.sta)) || (arrival.ata && (arrival.ata > arrival.sta)))
      f_info = f_info + "DLY| "
    end
    f_info = f_info + "Closed| " if arrival.is_approval
    f_info = f_info + "Correction| " if (arrival.notify_count && arrival.notify_count > 0)
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

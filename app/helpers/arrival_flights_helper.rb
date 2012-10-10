module ArrivalFlightsHelper
  def first_words(s, n)
    a = s.split(/\s/) # or /[ ]+/ to only split on spaces
    a[0...n].join(' ') + (a.size > n ? '...' : '')
  end
  
  def generate_further_information(arrival)
    f_info = ""
    if (!current_user.nil? && (current_user.has_role? :supervisor || current_user.has_role? :manager))
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
end

module ArrivalFlightsHelper
  def first_words(s, n)
    a = s.split(/\s/) # or /[ ]+/ to only split on spaces
    a[0...n].join(' ') + (a.size > n ? '...' : '')
  end
  
  def generate_further_information(arrival)
    f_info = ""
    if (arrival.outbounds.size > 0)
      f_info = f_info + "OB| "
    end
    unless (arrival.baggage.blank?)
      f_info = f_info + "BG| "
    end
    unless (arrival.irregular_information.blank?)
      f_info = f_info + "Irregular| "
    end
    if (arrival.irregular_information.blank? && !arrival.remarks.blank?)
      f_info = f_info + "Remarks| "
    end
    if ((arrival.eta && (arrival.eta > arrival.sta)) || (arrival.ata && (arrival.ata > arrival.sta)))
      f_info = f_info + "DLY| "
    end
    if arrival.is_approval
      f_info = f_info + "Aprroved| "
    end
    if (arrival.notify_count && arrival.notify_count > 0)
      f_info = f_info + "Correction| "
    end
    f_info
  end
end

module ArrivalFlightsHelper
  def first_words(s, n)
    a = s.split(/\s/) # or /[ ]+/ to only split on spaces
    a[0...n].join(' ') + (a.size > n ? '...' : '')
  end
  
  def generate_further_information(arrival)
    f_info = ""
    if (!arrival.remarks.nil?)
      f_info = f_info + "RMK."
    end
    if ((!arrival.eta.nil? && (arrival.eta > arrival.sta)) || (!arrival.ata.nil? && (arrival.ata > arrival.sta)))
      f_info = f_info + "DLY."
    end
    if arrival.is_approval
      f_info = f_info + "Closed."
    end
    f_info
  end
end

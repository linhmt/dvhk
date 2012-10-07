module OutboundsHelper
  def outbound_detail(ob_details)
    if ob_details
      str = ""
      ob_array = ob_details.split(',')
      ob_array.each do |item|
        str << item + "<br/>"
      end
      str
    else
      "nil"
    end
  end
end

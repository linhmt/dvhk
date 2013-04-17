class ShiftTrackingsController < ApplicationController
  def index
    @shift_trackings = ShiftTracking.all
  end

  def show
    @shifts = ShiftTracking.find(params[:id])
  end
  
  def edit_individual
    if params[:staff_ids].blank?
      redirect_to shift_trackings_url, notice: "Please choose at least one staff"
    else      
      @staffs = ShiftTracking.find(params[:staff_ids])
      for staff in @staffs
        staff.generate_attr_accessors
      end
    end
  end
  
  def update_individual
    for key in params[:staff].keys
      tracking = ShiftTracking.find(key)
      tracking.ot_time = 0
      (1..31).each do |day|
        ot = params[:staff][key]["ot_#{day}"]
        tracking.ot_time = tracking.ot_time + ot.to_d if ot.to_d > 0
        tracking.working_duties["d_#{day}".to_sym][2] = ot.to_s
      end
      tracking.calculate_month_overtime
      tracking.save!
    end
    redirect_to shift_trackings_path, notice: "Overtime of staffs updated!"
  end

end

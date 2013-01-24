class ShiftTrackingsController < ApplicationController
  def index
    @shift_trackings = ShiftTracking.all
  end

  def show
  end

end

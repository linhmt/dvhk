class WorkingShiftStaffsController < ApplicationController

  def index
    @working_shift_staffs = WorkingShiftStaff.all
  end

  def show
    @working_shift_staff = WorkingShiftStaff.find(params[:id])
  end

  def new
    @working_shift_staff = WorkingShiftStaff.new
    authorize! :new, @working_shift_staff, :message => 'You do not have right to mofify roster.'
  end
  
  def edit
    authorize! :edit, @user, :message => 'You do not have right to mofify roster.'
    @working_shift_staff = WorkingShiftStaff.find(params[:id])
  end

  # POST /working_shift_staffs
  def create
    @working_shift_staff = WorkingShiftStaff.new(params[:working_shift_staff])
    authorize! :create, @user, :message => 'You do not have right to mofify roster.'

    if @working_shift_staff.save
      redirect_to working_shift_staffs_path, notice: 'Working shift staff was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /working_shift_staffs/1
  def update
    @working_shift_staff = WorkingShiftStaff.find(params[:id])
    authorize! :update, @working_shift_staff, :message => 'You do not have right to mofify roster.'

    if @working_shift_staff.update_attributes(params[:working_shift_staff])
      redirect_to @working_shift_staff, notice: 'Working shift staff was successfully updated.'
    else
      render action: "edit" 
    end
  end
end

class WorkingShiftStaffsController < ApplicationController
  # GET /working_shift_staffs
  # GET /working_shift_staffs.json
  def index
    @working_shift_staffs = WorkingShiftStaff.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @working_shift_staffs }
    end
  end

  # GET /working_shift_staffs/1
  # GET /working_shift_staffs/1.json
  def show
    @working_shift_staff = WorkingShiftStaff.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @working_shift_staff }
    end
  end

  # GET /working_shift_staffs/new
  # GET /working_shift_staffs/new.json
  def new
    @working_shift_staff = WorkingShiftStaff.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @working_shift_staff }
    end
  end
  
  # GET /working_shift_staffs/1/edit
  def edit
    @working_shift_staff = WorkingShiftStaff.find(params[:id])
  end

  # POST /working_shift_staffs
  # POST /working_shift_staffs.json
  def create
    @working_shift_staff = WorkingShiftStaff.new(params[:working_shift_staff])

    if @working_shift_staff.save
      redirect_to working_shift_staffs_path, notice: 'Working shift staff was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /working_shift_staffs/1
  # PUT /working_shift_staffs/1.json
  def update
    @working_shift_staff = WorkingShiftStaff.find(params[:id])

    respond_to do |format|
      if @working_shift_staff.update_attributes(params[:working_shift_staff])
        format.html { redirect_to @working_shift_staff, notice: 'Working shift staff was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @working_shift_staff.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /working_shift_staffs/1
  # DELETE /working_shift_staffs/1.json
  def destroy
    @working_shift_staff = WorkingShiftStaff.find(params[:id])
    @working_shift_staff.destroy

    respond_to do |format|
      format.html { redirect_to working_shift_staffs_url }
      format.json { head :ok }
    end
  end
end

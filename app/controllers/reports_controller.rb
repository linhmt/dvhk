class ReportsController < ApplicationController
  # GET /reports
  # GET /reports.json
  def index
    @reports = Report.reports(params[:date])
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
    @report = Report.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @report }
    end
  end

  # GET /reports/new
  # GET /reports/new.json
  def new
    @report = Report.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @report }
    end
  end

  # GET /reports/1/edit
  def edit
    @report = Report.find(params[:id])
  end

  # POST /reports
  # POST /reports.json
  def create
#    begin
      @report = Report.new(params[:report])
      if @report.update_content(params[:report], current_user.id)
        redirect_to @report, notice: 'Report was successfully created.'
      else
        render action: "new"
      end
#    rescue
#      redirect_to reports_path, notice: 'Cannot create new report.'
#    end
  end

  # PUT /reports/1
  # PUT /reports/1.json
  def update
    @report = Report.find(params[:id])

    respond_to do |format|
      if @report.update_content(params[:report], current_user.id)
        format.html { redirect_to @report, notice: 'Report was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end
end

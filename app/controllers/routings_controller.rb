class RoutingsController < ApplicationController
  before_filter :authenticate_user!
  # GET /routings
  # GET /routings.json
  def index
    @routings = Routing.where("is_arrival is not true").order('destination asc')
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /routings/1 # show.html.erb
  def show
    @routing = Routing.find(params[:id])
    @passengers = @routing.standby_passengers
  end
  
  def show_accepted
    @routing = Routing.find(params[:id])
    @passengers = @routing.accepted_passengers
  end
  
  # GET /routings/new
  # GET /routings/new.json
  def new
    @routing = Routing.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @routing }
    end
  end

  # GET /routings/1/edit
  def edit
    @routing = Routing.find(params[:id])
  end

  # POST /routings
  # POST /routings.json
  def create
    @routing = Routing.new(params[:routing])

    respond_to do |format|
      if @routing.save
        format.html { redirect_to 'index', notice: 'Routing was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /routings/1
  # PUT /routings/1.json
  def update
    @routing = Routing.find(params[:id])

    respond_to do |format|
      if @routing.update_attributes(params[:routing])
        format.html { redirect_to @routing, notice: 'Routing was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @routing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /routings/1
  def destroy
    @routing = Routing.find(params[:id])
    @routing.destroy

    respond_to do |format|
      format.html { redirect_to routings_url }
      format.json { head :ok }
    end
  end
end

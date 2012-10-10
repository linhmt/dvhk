class RolesController < ApplicationController
  def index
    @roles = Role.all
  end
  
  def new
    @role = Role.new
  end
  
  def create
    begin
      @role = Role.new(params[:role])
      if @role.resource_type.blank?
        @role.resource_type = nil
      end
      if @role.save!
        redirect_to roles_path, notice: 'Role was successfully created.'
      else
        render action: "new"
      end
    rescue
      redirect_to roles_path, notice: 'Cannot create new report.'
    end
  end

end

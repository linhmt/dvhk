class NoticesController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :create, :delete, :update, :deactive]
  def index
    @notices = Notice.page(params[:page])
  end

  def show
    @notice = Notice.find(params[:id])
  end

  def create
    @notice = current_user.notices.build(params[:notice])
    if @notice.save
      flash[:notice] = "Notice is created!"
      redirect_to notices_path
    else
      flash[:error] = "Error!"
      render new_notice_path
    end
  end
  
  def edit
    @notice = Notice.find(params[:id])
  end
  
  def update
    @notice = Notice.find(params[:id])
    if (current_user)
      @notice.update_attributes(params[:notice])
      redirect_to notice_path(@notice), notice: "A briefing notice updated!"
    else
      redirect_to notices_path, error: "Nothing updated!"
    end
  end
  
  # update is_active=false is a delete
  def deactive
    notice = Notice.find(params[:id])
    if (current_user.can_delete_notice)
      notice.update_attribute(:is_active, false)
      redirect_to notices_path, notice: "A notice deleted!"
    else
      redirect_to notices_path, error: "Nothing updated!"
    end
  end
end
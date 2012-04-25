class ApplicationController < ActionController::Base
  protect_from_forgery
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end
  
  def current_important_notice
    imp_notice = Notice.where(:is_active => true).first
    imp_notice
  end
end

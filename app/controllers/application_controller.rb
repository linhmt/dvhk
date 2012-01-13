class ApplicationController < ActionController::Base
  protect_from_forgery
  def current_important_notice
    imp_notice = Notice.where(:is_active => true).first
    imp_notice
  end
end

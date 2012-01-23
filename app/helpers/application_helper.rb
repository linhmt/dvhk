module ApplicationHelper
  def current_important_notice
    imp_notice = Notice.where(:is_active => true).first
    if imp_notice.nil?
      notice = "Check out!!!"
    else
      notice = imp_notice.content
    end
    notice
  end
end

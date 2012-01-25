module ApplicationHelper
  def current_important_notice
    imp_notice = Notice.where(:is_active => true).first
    if imp_notice.nil?
      content = "Important notice will be displayed here. Please check it open!!!"
    else
      content = imp_notice.content
    end
    content
  end
end

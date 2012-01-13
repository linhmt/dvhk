module ApplicationHelper
  def current_important_notice
    imp_notice = Notice.where(:is_active => true).first
    imp_notice.content
  end
end

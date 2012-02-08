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
  
  def img_link_tag(name, icon, options={})
    icon_path = '/assets/web-app-theme/icons/'
    icon_path += icon
    img = tag("img", :src => icon_path,
      :alt =>"", :open => false)
    img << ' ' + name
    options.merge!(:href => 'root') unless options[:href]
    content_tag(:a, img, options)
  end
end

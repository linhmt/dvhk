module ApplicationHelper
  #
  # <button type="submit" class="button positive">
  #    <img src="/stylesheets/blueprint/plugins/buttons/icons/key.png" alt=""/> Sign Up
  # </button>
  #
  def button_image_tag(name, icon, options={})
    icon_path = '/images/web-app-theme/icons/'
    icon_path += icon
    img = tag("img", :src => icon,
      :alt =>"", :open => false)
    img << ' ' + name
    options.merge!(:type => 'submit') unless options[:type]
    content_tag(:button, img, options)
  end

  #
  #  <a class="button negative" href="/">
  #     <img src="/stylesheets/blueprint/plugins/buttons/icons/cross.png" alt=""/> Cancel
  #  </a>
  #
  def img_link_tag(name, icon, options={})
    icon_path = '/images/web-app-theme/icons/'
    icon_path += icon
    img = tag("img", :src => icon_path,
      :alt =>"", :open => false)
    img << ' ' + name
    options.merge!(:href => 'root') unless options[:href]
    content_tag(:a, img, options)
  end
end

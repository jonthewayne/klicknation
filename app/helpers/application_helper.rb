module ApplicationHelper
  # app version
  APP_VERSION = "1.2"
  
  def sortable(column, css_class, title)
    direction = css_class == "sort-down" ? "desc" : "asc"    
    css_class = column == sort_column && direction == sort_direction ? "#{css_class} active" : css_class
    link_to "", params.merge(:sort => column, :direction => direction, :page => nil), {:title => title, :class => css_class}
  end  
  def title(page_title)
    content_for(:title) { page_title }
  end
end

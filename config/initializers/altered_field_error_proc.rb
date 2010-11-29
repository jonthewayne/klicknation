# change how form and label fields are wrapped when there's an error. Normally they're in a div with
# class of field_with_errors. Changing to work with my skin.
ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
    if html_tag.include? "label"
      html_tag
    else
      # if html_tag has class declared already, then add to it, otherwise add class with error style at the first space
      html_tag = html_tag.include?("class=\"") ? html_tag.insert(html_tag.index("class=\"")+7, "error ") : html_tag.insert(html_tag.index(' '), " class=\"error\"") 
      "<span class=\"relative\">#{html_tag}<span class=\"check-error\"></span></span>".html_safe       
    end
end
        
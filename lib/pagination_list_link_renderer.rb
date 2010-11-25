class PaginationListLinkRenderer < WillPaginate::ViewHelpers::LinkRenderer

  protected

# what this class outputs originally:
#  <li class="previous_page"><a href="/users?page=1"> ← Previous</a></li>
#  <li><a href="/users?page=1">1</a></li>
#  <li class="current">2</li>
#  <li><a href="/users?page=3">3</a></li>
#  <li class="next_page"><a href="/users?page=3">Next →</a></li>

# what we want it to output:
#<li><a href="#" title="Previous"><img src="images/icons/fugue/navigation-180.png" width="16" height="16"> Prev</a></li>
#<li><a href="#" title="Page 1"><b>1</b></a></li>
#<li><a href="#" title="Page 2" class="current"><b>2</b></a></li>
#<li><a href="#" title="Page 3"><b>3</b></a></li>

#<li><a href="#" title="Page 4"><b>4</b></a></li>
#<li><a href="#" title="Page 5"><b>5</b></a></li>
#<li><a href="#" title="Next">Next <img src="images/icons/fugue/navigation.png" width="16" height="16"></a></li>
            
    def page_number(page)
      unless page == current_page
        tag(:li, link(page, page, :rel => rel_value(page)))
      else
        tag(:li, page, :class => "current")
      end
    end

    def previous_or_next_page(page, text, classname)
      # I want better alt tags, so I need to have nice name for whichever direction we're going
      direction_name = classname == "next_page" ? "Next" : "Previous"
      if page
        tag(:li, link(text, page), :class => classname)
      else
        tag(:li, text, :class => classname + ' disabled')
      end
    end

    def html_container(html)
      # no need to wrap li elements with our skin
    end

end
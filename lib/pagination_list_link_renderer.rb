class PaginationListLinkRenderer < WillPaginate::ViewHelpers::LinkRenderer

  protected

# what we want to output:
#<li><a href="#" title="Previous"><img src="images/icons/fugue/navigation-180.png" width="16" height="16"> Prev</a></li>
#<li><a href="#" title="Page 1"><b>1</b></a></li>
#<li><a href="#" title="Page 2" class="current"><b>2</b></a></li>
#<li><a href="#" title="Page 3"><b>3</b></a></li>

#<li><a href="#" title="Page 4"><b>4</b></a></li>
#<li><a href="#" title="Page 5"><b>5</b></a></li>
#<li><a href="#" title="Next">Next <img src="images/icons/fugue/navigation.png" width="16" height="16"></a></li>
            
    def page_number(page)
      unless page == current_page
        tag(:li, link(tag(:b, page), page, :rel => rel_value(page), :alt => "Page #{page.to_s}", :title => "Page #{page.to_s}"))
      else
        tag(:li, link(tag(:b, page), page, :alt => "Page #{page.to_s}", :title => "Page #{page.to_s}", :class => "current"))
      end
    end

    def previous_or_next_page(page, text, classname)
      # I want better alt tags, so I need to have nice name for whichever direction we're going
      nice_alt = classname == "next_page" ? "Next Page" : "Previous Page"
      if page
        tag(:li, link(text, page, :alt => nice_alt, :title => nice_alt))
      else
        # right now, I don't display a prev or next button is there is nothing prev or next
        # could also display button but make it unclickable. I would just alter the following.
        #tag(:li, link(text, "#", :alt => nice_alt, :title => nice_alt))
      end
    end
end
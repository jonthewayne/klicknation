$(function() {
  $("#pieces th a, #pagination a").live("click", function() {
    $.getScript(this.href);
    return false;
  });
 
  $("#pieces_search input").keyup(function() {
    $.get($("#pieces_search").attr("action"), $("#pieces_search").serialize(), null, "script");
    return false;
  });
  $('a.remote-delete').live("click", function() {
    // we just need to add the key/value pair for the DELETE method
    // as the second argument to the JQuery $.post() call
    if (confirm("Are you sure?")) {
      $.post(this.href, {
        _method: 'delete'
      }, null, "script");
    }
    return false;
  });  
});
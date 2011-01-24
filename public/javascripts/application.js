$(function() {
  $("#resources th a, #pagination a").live("click", function() {
    $.getScript(this.href);
    return false;
  }); 
  $("#resources_search input").keyup(function() {
    $.get($("#resources_search").attr("action"), $("#resources_search").serialize(), null, "script");
    return false;
  });
});
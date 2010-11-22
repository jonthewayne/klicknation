$(function() {
  $("#pieces th a, #pieces .pagination a").live("click", function() {
    $.getScript(this.href);
    return false;
  });
  $("#pieces_search input").keyup(function() {
    $.get($("#pieces_search").attr("action"), $("#pieces_search").serialize(), null, "script");
    return false;
  });
});
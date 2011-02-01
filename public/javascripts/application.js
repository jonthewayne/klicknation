$(function() {
  $("#resources th a, #pagination a").live("click", function() {
    $.getScript(this.href);
    return false;
  }); 
  $("#resources_search input").keyup(function() {
    $.get($("#resources_search").attr("action"), $("#resources_search").serialize(), null, "script");
    return false;
  });
  
  $('#item_name').keyup(function() {
      $('#ability_name_output').text($(this).val());
  });
  $('#item_description').keyup(function() {
      $('#ability_description_output').text($(this).val());
  });  
  $('#item_attack').keyup(function() {
      $('#item_attack_output').text($(this).val());
  });
  $('#item_defense').keyup(function() {
      $('#item_defense_output').text($(this).val());
  });    
  $('#item_agility').keyup(function() {
      $('#item_agility_output').text($(this).val());
  });     
});
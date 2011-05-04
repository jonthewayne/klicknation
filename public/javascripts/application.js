$(function() {
  // index view js
  $("#resources th a, #pagination a").live("click", function() {
    $.getScript(this.href);
    return false;
  }); 
  $("#resources_search input").keyup(function() {
    $.get($("#resources_search").attr("action"), $("#resources_search").serialize(), null, "script");
    return false;
  });
  
  // live update the item card display
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
  
  // helper functions
  function type_label(type) {
    return "attack defense movement 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 attack defense movement".split(" ")[type]
    // a = new Array(17); a.splice(0, 0, 'attack', 'defense', 'movement'); a.push('attack', 'defense', 'movement'); a[type]
  }
  function ability_label(ability_id) {
    return "none fire water air kinetic tech earth psychic light dark".split(" ")[ability_id]
  }
  function class_label(klass) {
    return "special alpha gamma omega".split(" ")[klass]
  }
  
  $('#item_type').change(function() {
    // hide or show item category dropdown depending on the item type dropdown
    var x = $(this).val();
    if (x != 0 && x != 20) {
        $('label[for=item_Item Category], #item_item_category_id').hide();
        $('label[for=item_Animation Manager], #item_animation_manager').hide();        
    } 
    else {
        $('label[for=item_Item Category], #item_item_category_id').show();
        $('label[for=item_Animation Manager], #item_animation_manager').show();         
    }  
    
    // change the card display type class depending on the item type dropdown
    $('#ability_card_type').removeClass().addClass('ability_card card_' + type_label(x));
  });  
  
  $('#item_klass').change(function() {
    var x = $(this).val();
    // change the card display border class depending on the item klass dropdown
    $('#ability_card_border').removeClass().addClass('ability_border class_' + class_label(x));    
  }); 
  
  $('#item_ability_element_id').change(function() {
    var x = $(this).val();
    // change the card display label class depending on the item type dropdown
    $('#ability_card_label').removeClass().addClass('ability_label type_' + ability_label(x));   
  });     
  
  // alert user if they are creating a pending item and have no animation selected
  $("form[id *= '_item']").submit(function(f) {
    var t = $('#item_type').val();
    var a = $('#item_item_category_id').val();
    if (t == 0 && a == 0) {
      if (confirm("Are you sure you want to save this production attack ability without selecting an animation from the Item category drop-down box?")) {
        // form submits
      }
      else {
        f.preventDefault();
      }        
    } 
    else {
        return true;
    } 
  });  
});
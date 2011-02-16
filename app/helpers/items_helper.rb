module ItemsHelper
  def type_label(type)
    %w(Attack Defense Movement)[type.to_i]
  end
  
  def ability_label(ability_id)
    %w(None Fire Water Air Kinetic Tech Earth Psychic Light Dark)[ability_id]
  end  
  
  def class_label(klass)
    %w(Special Alpha Gamma Omega)[klass]
  end    
  
  def item_id_label(item)
    if item.new_record?
      ""
    else
      " ##{item.id}"
    end
  end
  
  def item_label(item)
    # for merit abilities
    if item.currency_type.to_s == "1"
      "Class #{item.klass} #{type_label(item.type)}#{item_id_label(item)}"
    else
      "Item #{item_id_label(item)}"
    end
  end
end

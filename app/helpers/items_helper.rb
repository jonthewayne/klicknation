module ItemsHelper
  def type_label(type)
    %w(Attack Defense Movement).insert(20,"Attack","Defense","Movement")[type.to_i]
  end
  
  def ability_label(ability_id)
    # there is no 0 ability id, but when it is nil, it selects the 0 index, so we'll use it to match with 
    # the drop down default of Fire 
    %w(Fire Fire Water Air Kinetic Tech Earth Psychic Light Dark)[ability_id]
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
      (item.new_record?) ? "New Class #{item.klass} #{type_label(item.type)}#{item_id_label(item)}" : "Editing Class #{item.klass} #{type_label(item.type)}#{item_id_label(item)}"
    else
      (item.new_record?) ? "New Item #{item_id_label(item)}" : "Editing Item #{item_id_label(item)}"
    end
  end
end

module ItemsHelper
  def type_label(type)
    %w(Attack Defense Movement)[type.to_i]
  end
  
  
end

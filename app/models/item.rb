class Item < ActiveRecord::Base
  # items has type column not used for single table inheritance, so change sti column
  self.inheritance_column = :item_type
  
  before_validation :set_defaults
  
  validates :name, :presence => true, :length => {:minimum => 1, :maximum => 60}
                    
  validates :description, :presence => true
                    
  validates :type, :presence => true, :inclusion => { :in => %w(0 1 2 3 4) }, :message => "%{value} is not a valid item type"
                    
  validates :price, :presence => true, :numericality => true
                    
  validates :currency_type, :presence => true, :inclusion => { :in => %w(0 1) }
                    
  validates :price, :presence => true, :numericality => true
                    
  validates :attack, :presence => true, :numericality => { :only_integer => true }, :length => {:minimum => 1, :maximum => 6}
                    
  validates :defense, :presence => true, :numericality => { :only_integer => true }, :length => {:minimum => 1, :maximum => 5}
                    
  validates :agility, :presence => true, :numericality => { :only_integer => true }, :length => {:minimum => 1, :maximum => 6}
                    
  validates :num_available, :presence => true, :numericality => { :only_integer => true }, :length => {:minimum => 1, :maximum => 6}
                    
  validates :available_on,  :presence => true
                    
  validates :available_until,  :presence => true
                    
  validates :level, :presence => true, :numericality => { :only_integer => true }
                    
  validates :ability_element_id, :presence => true, :numericality => { :only_integer => true }, :length => {:minimum => 1, :maximum => 6}
                    
  validates :rarity, :presence => true, :inclusion => { :in => %w(0 1 2) }, :message => "%{value} is not a valid rarity type"
                    
  validates :photo, :presence => true, :length => {:minimum => 1, :maximum => 200}
  
  validates :swf, :length => {:minimum => 1, :maximum => 255}  
                    
  validates :item_category_id, :presence => true, :numericality => { :only_integer => true }, :length => {:minimum => 1, :maximum => 3}
                    
  validates :city, :presence => true, :numericality => { :only_integer => true }
                    
  validates :sort, :presence => true, :numericality => { :only_integer => true }, :length => {:minimum => 1, :maximum => 5}
                    
  validates :class, :presence => true, :inclusion => { :in => %w(0 1 2 3) }, :message => "%{value} is not a valid class type"
                    
  validates :force_show_card, :inclusion => { :in => [true, false] }
                    
  validates :i_can_has, :inclusion => { :in => [true, false] }
                    
  validates :sell_isolated, :inclusion => { :in => [true, false] }
                    
  validates :apply_discount, :inclusion => { :in => [true, false] }
  
  

  def self.search(search)
    if search
      where('name LIKE ?', "%#{search}%") 
    else
      scoped
    end
  end
  
  protected
  def set_defaults
    # app id is always 1
    self.app_id = 1
    self.sort = 0 # default if not a merit ability
  end  
end

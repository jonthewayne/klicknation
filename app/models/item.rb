class Item < ActiveRecord::Base
  # items has type column not used for single table inheritance, so change sti column
  self.inheritance_column = :item_type
  
  # deal with other legacy column names http://bit.ly/dLECXz
  bad_attribute_names :class
  
  before_validation :set_defaults
  
  ### Not allowed to be null: (id and app_id are taken care of by set_defaults)

  validates :type, :presence => true, :inclusion => { :in => %w(0 1 2 3 4), :message => "%{value} is not a valid item type" }
                    
  validates :price, :presence => true, :numericality => true
                    
  validates :currency_type, :presence => true, :inclusion => { :in => %w(0 1) }
  
  # default to 0
  validates :upkeep, :presence => true, :numericality => true
  
  validates :attack, :presence => true, :numericality => { :only_integer => true }, :length => {:minimum => 1, :maximum => 6}
                    
  validates :defense, :presence => true, :numericality => { :only_integer => true }, :length => {:minimum => 1, :maximum => 5}  

  validates :agility, :presence => true, :numericality => { :only_integer => true }, :length => {:minimum => 1, :maximum => 6}
                    
  validates :num_available, :presence => true, :numericality => { :only_integer => true }, :length => {:minimum => 1, :maximum => 6}
                    
  validates :level, :presence => true, :numericality => { :only_integer => true }
                    
  validates :ability_element_id, :presence => true, :numericality => { :only_integer => true }, :length => {:minimum => 1, :maximum => 6}
                    
  validates :rarity, :presence => true, :inclusion => { :in => %w(0 1 2), :message => "%{value} is not a valid rarity type" }

  # only req for attack (type = 0) merit abilities, otherwise default to 0
  validates :item_category_id, :presence => true, :numericality => { :only_integer => true }, :length => {:minimum => 1, :maximum => 3}
  
  # default to 1 even though not used for stock merit abilities
  validates :apply_discount, :inclusion => { :in => [true, false] }
  
  
  ### Allowed to be null:
  
  validates :name, :presence => true, :length => {:minimum => 1, :maximum => 60}
                    
  validates :description, :presence => true
                    
  validates :photo, :presence => true, :length => {:minimum => 1, :maximum => 200}
  
  validates :sort, :presence => true, :numericality => { :only_integer => true }, :length => {:minimum => 1, :maximum => 5}
                    
  validates :class_name, :presence => true, :inclusion => { :in => %w(0 1 2 3), :message => "%{value} is not a valid class type" }
  
  
  ## Not used for stock merit abilities:

  #validates :available_on, :presence => true
                    
  #validates :available_until, :presence => true
  
  #validates :swf, :length => {:minimum => 1, :maximum => 255}  
                    
  #validates :city, :presence => true, :numericality => { :only_integer => true }
                                     
  #validates :force_show_card, :inclusion => { :in => [true, false] }
                    
  #validates :i_can_has, :inclusion => { :in => [true, false] }
                    
  #validates :sell_isolated, :inclusion => { :in => [true, false] }
         


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
    
    # set defaults for stock merit abilities
    if self.currency_type && self.type && self.currency_type == 1 #&& [0, 1, 2].include? self.type
      self.sort = 0
      
    end
  end  
end

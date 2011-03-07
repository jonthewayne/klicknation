class Item < ActiveRecord::Base
  # items has type column not used for single table inheritance, so change sti column
  self.inheritance_column = :item_type
  
  # deal with other legacy column names http://bit.ly/dLECXz
  bad_attribute_names :class

  # give class column benign accessors
  def klass= value
    self[:class] = value
  end

  def klass
    self[:class]
  end

  scope :all_merit_abilities, where("items.sort > 0 AND items.currency_type = 1 AND items.num_available > 0 AND (items.class IN (1,2,3)) AND (items.type IN (0,1,2,20,21,22)) AND (items.level IN (1,40,80))").order("class, sort")  
  scope :production_merit_abilities, where("items.sort > 0 AND items.currency_type = 1 AND items.num_available > 0 AND (items.class IN (1,2,3)) AND (items.type IN (0,1,2)) AND (items.level IN (1,40,80))").order("class, sort")  
  scope :pending_merit_abilities, where("items.sort > 0 AND items.currency_type = 1 AND items.num_available > 0 AND (items.class IN (1,2,3)) AND (items.type IN (20,21,22)) AND (items.level IN (1,40,80))").order("id")  

  
  before_validation :set_defaults
  
  ### Not allowed to be null: (id and app_id are taken care of by set_defaults)

  validates :type, :presence => true, :inclusion => { :in => [0,1,2,3,4,20,21,22], :message => "%{value} is not a valid item type" }
                    
  validates :price, :presence => true, :numericality => true
                    
  validates :currency_type, :presence => true, :inclusion => { :in => %w(0 1) }
  
  validates :upkeep, :presence => true, :numericality => true
  
  validates :attack, :presence => true, :numericality => { :only_integer => true }, :length => {:minimum => 1, :maximum => 6}
                    
  validates :defense, :presence => true, :numericality => { :only_integer => true }, :length => {:minimum => 1, :maximum => 5}  

  validates :agility, :presence => true, :numericality => { :only_integer => true }, :length => {:minimum => 1, :maximum => 6}
                    
  validates :num_available, :presence => true, :numericality => { :only_integer => true }, :length => {:minimum => 1, :maximum => 6}
                    
  validates :level, :presence => true, :numericality => { :only_integer => true }
                    
  validates :ability_element_id, :presence => true, :numericality => { :only_integer => true }, :length => {:minimum => 1, :maximum => 6}
                    
  validates :rarity, :presence => true, :inclusion => { :in => [0,1,2], :message => "%{value} is not a valid rarity type" }

  # only req for attack (type = 0) merit abilities, otherwise defaults to 0
  validates :item_category_id, :presence => true, :numericality => { :only_integer => true }, :length => {:minimum => 1, :maximum => 5}
  
  # default to 1 even though not used for stock merit abilities
  validates :apply_discount, :inclusion => { :in => [1, 0] }
  
  
  ### Allowed to be null by db:
  
  validates :name, :presence => true, :length => {:minimum => 1, :maximum => 60}
                    
  validates :description, :presence => true
                    
  validates :photo, :presence => true, :length => {:minimum => 1, :maximum => 200}
  
  validates :sort, :presence => true, :numericality => { :only_integer => true }, :length => {:minimum => 1, :maximum => 5}
   
  validates :klass, :presence => true, :inclusion => { :in => [0,1,2,3], :message => "%{value} is not a valid class type" }
  
  
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
  
  
  # this is called before item validation
  def set_defaults    
    # set defaults for stock merit abilities. Overwriting mysql column defaults if new record, 
    # otherwise accept edit params
    if self.currency_type == "1"      
      if self.klass == 1 && self.type == 0
        self.sort = self.new_record? ? set_sort(self.klass,self.type) : self.sort
        self.price = self.new_record? ? 25.0 : self.price         
        self.num_available = self.new_record? ? 7000 : self.num_available 
        self.level = self.new_record? ? 1 : self.level        
      elsif self.klass == 1 && self.type == 1
        self.sort = self.new_record? ? set_sort(self.klass,self.type) : self.sort 
        self.price = self.new_record? ? 20.0 : self.price        
        self.num_available = self.new_record? ? 7000 : self.num_available
        self.level = self.new_record? ? 1 : self.level             
      elsif self.klass == 1 && self.type == 2
        self.sort = self.new_record? ? set_sort(self.klass,self.type) : self.sort 
        self.price = self.new_record? ? 35.0 : self.price        
        self.num_available = self.new_record? ? 3500 : self.num_available
        self.level = self.new_record? ? 1 : self.level              
      elsif self.klass == 2 && self.type == 0
        self.sort = self.new_record? ? set_sort(self.klass,self.type) : self.sort 
        self.price = self.new_record? ? 35.0 : self.price        
        self.num_available = self.new_record? ? 3000 : self.num_available
        self.level = self.new_record? ? 40 : self.level              
      elsif self.klass == 2 && self.type == 1
        self.sort = self.new_record? ? set_sort(self.klass,self.type) : self.sort 
        self.price = self.new_record? ? 30.0 : self.price        
        self.num_available = self.new_record? ? 3000 : self.num_available
        self.level = self.new_record? ? 40 : self.level               
      elsif self.klass == 2 && self.type == 2
        self.sort = self.new_record? ? set_sort(self.klass,self.type) : self.sort 
        self.price = self.new_record? ? 53.0 : self.price        
        self.num_available = self.new_record? ? 3000 : self.num_available
        self.level = self.new_record? ? 40 : self.level               
      elsif self.klass == 3 && self.type == 0
        self.sort = self.new_record? ? set_sort(self.klass,self.type) : self.sort 
        self.price = self.new_record? ? 45.0 : self.price        
        self.num_available = self.new_record? ? 3500 : self.num_available
        self.level = self.new_record? ? 80 : self.level               
      elsif self.klass == 3 && self.type == 1
        self.sort = self.new_record? ? set_sort(self.klass,self.type) : self.sort 
        self.price = self.new_record? ? 40.0 : self.price        
        self.num_available = self.new_record? ? 3500 : self.num_available
        self.level = self.new_record? ? 80 : self.level              
      elsif self.klass == 3 && self.type == 2        
        self.sort = self.new_record? ? set_sort(self.klass,self.type) : self.sort 
        self.price = self.new_record? ? 68.0 : self.price        
        self.num_available = self.new_record? ? 3500 : self.num_available
        self.level = self.new_record? ? 80 : self.level              
      end
    else
      # for non-merit abilities, will differentiate further later   
    end
  end  
  
  def set_sort(c, t)
    # increment from last item of same class and type
    self.sort = Item.where("class = ? AND type = ? AND num_available > 0", c, t).last.sort + 1
  end
end

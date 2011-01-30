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

  
  before_validation :set_defaults
  
  ### Not allowed to be null: (id and app_id are taken care of by set_defaults)

  validates :type, :presence => true, :inclusion => { :in => %w(0 1 2 3 4), :message => "%{value} is not a valid item type" }
                    
  validates :price, :presence => true, :numericality => true
                    
  validates :currency_type, :presence => true, :inclusion => { :in => %w(0 1) }
  
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
  
  
  ### Allowed to be null by db:
  
  validates :name, :presence => true, :length => {:minimum => 1, :maximum => 60}
                    
  validates :description, :presence => true
                    
  validates :photo, :presence => true, :length => {:minimum => 1, :maximum => 200}
  
  validates :sort, :presence => true, :numericality => { :only_integer => true }, :length => {:minimum => 1, :maximum => 5}
   
  validates :klass, :presence => true, :inclusion => { :in => %w(0 1 2 3), :message => "%{value} is not a valid class type" }
  
  
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
  
  # this is called before item validation
  def set_defaults(item)
    self.app_id ||= 1 # app id is always 1
    self.upkeep ||= 0
    self.item_category_id ||= 0
    self.apply_discount ||= 1  
    
    # set defaults for stock merit abilities
    if self.currency_type == 1 
      self.rarity ||= 2     
      
      if self.klass == 1 && self.type == 0
        self.sort ||= set_sort(self.klass,self.type) 
        self.price ||= 25        
        self.num_available ||= 7000
        self.level ||= 1        
      elsif self.klass == 1 && self.type == 1
        self.sort ||= set_sort(self.klass,self.type) 
        self.price ||= 20        
        self.num_available ||= 7000
        self.level ||= 1              
      elsif self.klass == 1 && self.type == 2
        self.sort ||= set_sort(self.klass,self.type) 
        self.price ||= 35        
        self.num_available ||= 3500
        self.level ||= 1              
      elsif self.klass == 2 && self.type == 0
        self.sort ||= set_sort(self.klass,self.type) 
        self.price ||= 35        
        self.num_available ||= 3000
        self.level ||= 40              
      elsif self.klass == 2 && self.type == 1
        self.sort ||= set_sort(self.klass,self.type) 
        self.price ||= 30        
        self.num_available ||= 3000
        self.level ||= 40              
      elsif self.klass == 2 && self.type == 2
        self.sort ||= set_sort(self.klass,self.type) 
        self.price ||= 53        
        self.num_available ||= 3000
        self.level ||= 40              
      elsif self.klass == 3 && self.type == 0
        self.sort ||= set_sort(self.klass,self.type) 
        self.price ||= 45        
        self.num_available ||= 3500
        self.level ||= 80              
      elsif self.klass == 3 && self.type == 1
        self.sort ||= set_sort(self.klass,self.type) 
        self.price ||= 40        
        self.num_available ||= 3500
        self.level ||= 80              
      elsif self.klass == 3 && self.type == 2        
        self.sort ||= set_sort(self.klass,self.type) 
        self.price ||= 68        
        self.num_available ||= 3500
        self.level ||= 80              
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

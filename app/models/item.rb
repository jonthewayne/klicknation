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
  
  # below is for carrierwave
  #mount_uploader :photo, ImageUploader
  
  
  # create accessors for paperclip's image_file_name that maps to our photo column, allowing us to store the full url
  def image_file_name= value
    bucket = ENV['S3_BUCKET']
    full_url = "http://#{bucket}/apps/heros/assets/abilities/" + %w(attack defense movement).insert(20,"attack","defense","movement")[self[:type].to_i] + "/#{value}"
    self[:photo] = full_url
  end

  def image_file_name
    self[:photo].blank? ? nil : self[:photo].split('/').last
  end  
  
  attr_accessor :image_file_size, :image_content_type, :image_updated_at
  
  # paperclip
  has_attached_file :image, :styles => { :original => "1000x1000>", :card => "150x150#", :small => "90x90#" }, :storage => :s3,
                    :s3_credentials => { :access_key_id => ENV['S3_KEY'] , :secret_access_key => ENV['S3_SECRET']  },
                    :bucket => ENV['S3_BUCKET'],
                    :path => "apps/heros/assets/abilities/:stockitemtype/:stockitemname.:extension",
                    :default_url => '/images/icons/fugue/question-white.png'
                    
  validates_attachment_size :image, :less_than => 5.megabytes
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png', 'image/pjpeg', 'image/x-png' ] 
  
  before_post_process :randomize_file_name  
  
  scope :all_merit_abilities, where("items.sort > 0 AND items.currency_type = 1 AND items.num_available > 0 AND (items.class IN (1,2,3)) AND (items.type IN (0,1,2,20,21,22)) AND (items.level IN (1,40,80))").order("class, sort")  
  scope :production_merit_abilities, where("items.sort > 0 AND items.currency_type = 1 AND items.num_available > 0 AND (items.class IN (1,2,3)) AND (items.type IN (0,1,2)) AND (items.level IN (1,40,80))").order("class, sort")  
  scope :pending_merit_abilities, where("items.sort > 0 AND items.currency_type = 1 AND items.num_available > 0 AND (items.class IN (1,2,3)) AND (items.type IN (20,21,22)) AND (items.level IN (1,40,80))").order("id")  

  before_validation :set_pending_defaults, :if => "!production?"  
  before_validation :set_production_defaults, :if => :production?

  ### Not allowed to be null: (id and app_id are taken care of by mysql default)

  validates :type, :presence => true, :inclusion => { :in => [0,1,2,3,4,20,21,22], :message => "%{value} is not a valid item type" }
  
  # mysql defaults to 0.00
  validates :price, :presence => true, :numericality => true 
  
  # mysql defaults to 1
  validates :currency_type, :presence => true, :inclusion => { :in => %w(0 1) } 
  
  # mysql defaults to 0.00
  validates :upkeep, :presence => true, :numericality => true 
  
  # mysql defaults to 0 
  validates :attack, :presence => true, :numericality => { :only_integer => true }

  # mysql defaults to 0                   
  validates :defense, :presence => true, :numericality => { :only_integer => true } 

  # mysql defaults to 0 
  validates :agility, :presence => true, :numericality => { :only_integer => true } 
  
  # mysql defaults to -1
  validates :num_available, :presence => true, :numericality => { :only_integer => true } 
  
  # mysql defaults to 1
  validates :level, :presence => true, :numericality => { :only_integer => true } 

  # mysql defaults to 0
  validates :ability_element_id, :presence => true, :numericality => { :only_integer => true }
  
  # mysql defaults to 2
  validates :rarity, :presence => true, :inclusion => { :in => [0,1,2], :message => "%{value} is not a valid rarity type" } 

  # only req for attack (type = 0) merit abilities, otherwise mysql defaults to 0
  validates :item_category_id, :presence => true, :numericality => { :only_integer => true }
  
  # mysql defaults to 1 even though not used for stock merit abilities
  validates :apply_discount, :inclusion => { :in => [1, 0] }
  
  
  ### Allowed to be null by db, but needed for stock merit abilities:
  
  validates :name, :presence => true, :length => {:minimum => 1, :maximum => 60}
                    
  validates :description, :presence => true, :if => :production?
                                
  validates :photo, :presence => true, :if => :production?
  
  validates :sort, :presence => true, :numericality => { :only_integer => true }, :if => :production?
   
  # neither validation would work on heroku. 
  #validates :klass, :presence => true , :inclusion => { :in => [0,1,2,3], :message => "%{value} is not a valid class type" }
  
  
  ## Allowed to be null, not used for stock merit abilities:

  #validates :available_on, :presence => true
                    
  #validates :available_until, :presence => true
  
  #validates :swf, :length => {:minimum => 1, :maximum => 255}  
                    
  #validates :city, :presence => true, :numericality => { :only_integer => true }
                                     
  #validates :force_show_card, :inclusion => { :in => [true, false] }
                    
  #validates :i_can_has, :inclusion => { :in => [true, false] }
                    
  #validates :sell_isolated, :inclusion => { :in => [true, false] }
         
         
  def production?
    %w[0 1 2 3 4].include? type.to_s
  end

  def self.search(search)
    if search
      # postgre db on heroku uses ILIKE for case-insensitive searching
      if Rails.env.production?
        # on heroku I can check to see if we're using postgre 
        if ENV['DATABASE_URL'].include? 'postgre'
          where('name ILIKE ?', "%#{search}%")
        else # otherwise we're using klicknation's mysql server
          where('name LIKE ?', "%#{search}%")
        end
      elsif Rails.env.development?
        where('name LIKE ?', "%#{search}%")
      end
    else
      scoped
    end
  end
  
  def set_pending_defaults
    # num_available mysql defaults to -1. We need a number greater than 0 for our index view query to work well
    # if doesn't matter if we hardcode this value for pending items since this value will default to something else
    # when the item is turned into a production item later.
    self.num_available = 1
    self.sort = 1
    self.attack ||= 1
    self.defense ||= 1
    self.agility ||= 1    
  end
  
  # this is called before item validation
  def set_production_defaults    
    # set defaults for stock merit abilities. Overwriting mysql column defaults if new record, 
    # otherwise accept edit params
    if self.currency_type == "1" && (self.new_record? or class_or_type_change?)
      if self.klass == 1 && self.type == 0
        self.sort = set_sort(self.klass,self.type)
        self.price = 25.0         
        self.num_available = 7000
        self.level = 1       
      elsif self.klass == 1 && self.type == 1
        self.sort = set_sort(self.klass,self.type) 
        self.price = 20.0        
        self.num_available = 7000
        self.level = 1            
      elsif self.klass == 1 && self.type == 2
        self.sort = set_sort(self.klass,self.type) 
        self.price = 35.0        
        self.num_available = 3500
        self.level = 1             
      elsif self.klass == 2 && self.type == 0
        self.sort = set_sort(self.klass,self.type) 
        self.price = 35.0        
        self.num_available = 3000
        self.level = 40             
      elsif self.klass == 2 && self.type == 1
        self.sort = set_sort(self.klass,self.type) 
        self.price = 30.0        
        self.num_available = 3000
        self.level = 40              
      elsif self.klass == 2 && self.type == 2
        self.sort = set_sort(self.klass,self.type) 
        self.price = 53.0        
        self.num_available = 3000
        self.level = 40              
      elsif self.klass == 3 && self.type == 0
        self.sort = set_sort(self.klass,self.type) 
        self.price = 45.0        
        self.num_available = 3500
        self.level = 80              
      elsif self.klass == 3 && self.type == 1
        self.sort = set_sort(self.klass,self.type) 
        self.price = 40.0        
        self.num_available = 3500
        self.level = 80             
      elsif self.klass == 3 && self.type == 2        
        self.sort = set_sort(self.klass,self.type) 
        self.price = 68.0        
        self.num_available = 3500
        self.level = 80             
      end
    else
      # for non-merit abilities, will differentiate further later   
    end
  end  
  
  def class_or_type_change?
    # compare to this item's last saved type
    last_save = Item.where("id = ?", self.id).first
    (![self.type].include? last_save.type) or (![self.klass].include? last_save.klass)
  end
  
  def set_sort(c, t)
    # increment from last item of same class and type. 
    self.sort = Item.where("class = ? AND type = ? AND num_available > 0", c, t).last.sort + 1
    # There should always be a last item in production, but we'll default to 70
    self.sort ||= 70
  end
  
  private 
  
  def randomize_file_name
    extension = File.extname(image_file_name).downcase
    # use the old filename sans ext if it exists, otherwise generate new random filename
    file_name = photo_change[0].blank? ? ActiveSupport::SecureRandom.hex(4) : "#{photo_change[0].split('/').last.split('.').first}"
    # add the _style if there is one, else style is the filename sans extension "t_card.png".split('.').first.split('_').last
    #style = image_file_name.split('.').first.split('_').last
    #file_name = (style != image_file_name.split('.').first) ? "#{file_name}_#{style}" : file_name
    self.image.instance_write(:file_name, "#{file_name}#{extension}")
  end  
end

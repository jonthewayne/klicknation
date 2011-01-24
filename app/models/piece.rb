class Piece < ActiveRecord::Base
  validates_presence_of :name, :attack, :defense, :movement, :cost

  validates_numericality_of :attack, :only_integer => true, :greater_than_or_equal_to => 0, :message => "can only be a whole positive number greater than or equal to 0."
  validates_numericality_of :defense, :only_integer => true, :greater_than_or_equal_to => 0, :message => "can only be a whole positive number greater than or equal to 0."
  validates_numericality_of :movement, :only_integer => true, :greater_than_or_equal_to => 0, :message => "can only be a whole positive number greater than or equal to 0."
  validates_numericality_of :cost, :only_integer => true, :greater_than_or_equal_to => 0, :message => "can only be a whole positive number greater than or equal to 0."
  
  
  has_attached_file :image, :styles => { :small => "50x50>", :medium => "100x100>" }, :storage => :s3,
                    :s3_credentials => { :access_key_id => S3[:key], :secret_access_key => S3[:secret] },
                    :bucket => S3[:bucket],
                    :path => ":class/:attachment/:style/:id.:extension",
                    :default_url => '/images/icons/fugue/question-white.png'


  #validates_attachment_presence :image
  validates_attachment_size :image, :less_than => 5.megabytes
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png', 'image/pjpeg', 'image/x-png' ] 
  
  def self.search(search)
    if search
      where('name LIKE ?', "%#{search}%") 
    else
      scoped
    end
  end
end

class ItemCategory < ActiveRecord::Base
  validates_presence_of :app, :category
  before_validation :set_defaults
  
  def self.search(search)
    if search
      where('category LIKE ?', "%#{search}%") 
    else
      scoped
    end
  end

  protected
  
  # this is called before item validation
  def set_defaults
    self.app ||= 1 # app is always 1
  end
end

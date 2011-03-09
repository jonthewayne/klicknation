class ItemCategory < ActiveRecord::Base
  validates_presence_of :app, :category
  before_validation :set_defaults
  
  def self.search(search)
    if search
      # postgre db on heroku uses ILIKE for case-insensitive searching
      if Rails.env.production?
        # on heroku I can check to see if we're using postgre 
        if ENV['DATABASE_URL'].include? 'postgre'
          where('category ILIKE ?', "%#{search}%")
        else # otherwise we're using klicknation's mysql server
          where('category LIKE ?', "%#{search}%")
        end
      elsif Rails.env.development?
        where('category LIKE ?', "%#{search}%")
      end
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

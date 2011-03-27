class AdminToolUser < ActiveRecord::Base
  # Setup accessible (or protected) attributes for the model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name
  
  validates_presence_of :first_name, :last_name
  validates_presence_of :roles_mask, :message => "can't be unchecked"
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :registerable, :lockable and :timeoutable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable
  
  validate :password_must_exist, :password_must_match, :password_length, :if => :password_required?
  
  scope :with_role, lambda { |role| where("roles_mask & #{2**ROLES.index(role.to_s)} > 0") }
  
  ROLES = %w[super_admin superhero_city_admin superhero_city_contributor]
  
  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum
  end
  
  def roles
    ROLES.reject { |r| ((roles_mask || 0) & 2**ROLES.index(r)).zero? }
  end
  
  def self.search(search)
    if search
      # postgre db on heroku uses ILIKE for case-insensitive searching
      if Rails.env.production?
        # on heroku I can check to see if we're using postgre 
        if ENV['DATABASE_URL'].include? 'postgre'
          where('last_name ILIKE ?', "%#{search}%")
        else # otherwise we're using klicknation's mysql server
          where('last_name LIKE ?', "%#{search}%")
        end
      elsif Rails.env.development?
        where('last_name LIKE ?', "%#{search}%")
      end
    else
      scoped
    end
  end
  
  protected
  def password_required?
    !persisted? || (password.present? && password_confirmation.present?)
  end  
  def password_must_exist
    errors.add(:password, "can't be blank") if password.blank?
  end
 
  def password_must_match
    errors.add(:password, "doesn't match confirmation") if password != password_confirmation
  end  
  def password_length
    errors.add(:password, "must be at least 6 characters long (and less than 30)") if (password.split(//).size < 6 || password.split(//).size > 29)
  end    
end

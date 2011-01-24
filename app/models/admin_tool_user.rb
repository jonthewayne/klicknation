class AdminToolUser < ActiveRecord::Base
  # Setup accessible (or protected) attributes for the model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :roles_mask, :roles
  
  validates_presence_of :first_name, :last_name
  validates_presence_of :roles_mask, :message => "can't be unchecked"
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :registerable, :lockable and :timeoutable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable  
  
  
  scope :with_role, lambda { |role| where("roles_mask & #{2**ROLES.index(role.to_s)} > 0") }
  
  ROLES = %w[super_admin superhero_city_admin age_of_champions_admin]
  
  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum
  end
  
  def roles
    ROLES.reject { |r| ((roles_mask || 0) & 2**ROLES.index(r)).zero? }
  end
  
  def self.search(search)
    if search
      where('last_name LIKE ?', "%#{search}%") 
    else
      scoped
    end
  end
  
protected
  def password_required?
    !persisted? || password.present? || password_confirmation.present?
  end
end

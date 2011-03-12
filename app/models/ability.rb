class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)

    # Cancan by default maps :create to cover the new and create actions- :update covers edit and update actions
    # In this app, we often let users view the new or edit actions, but not be able to use create or update controller actions
    # We have to set custom aliases to allow this behavior 
    alias_action :new, :to => :view_new
    alias_action :edit, :to => :view_edit
    
    # give super admins complete access
    if user.roles.include?('super_admin')
      can :manage, :all
    elsif user.roles.include?('superhero_city_admin')
      can :manage, Item
      can :manage, ItemCategory
      # allow non super admin to update their own user record
      can :update, AdminToolUser, :id => user.id
    elsif user.roles.include?('superhero_city_contributor')
      can :read, ItemCategory
      can [:read, :view_new, :view_edit], Item
      # allow contributors to manage pending items only
      can [:destroy, :create, :update], Item, :type => 20..22
      #can [:destroy], Item, :type => 20..22      
    else
      # allow non super admin to update their own user record
      can :update, AdminToolUser, :id => user.id      
      can :read, Item
    end
    
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end

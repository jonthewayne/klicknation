class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :authenticate_admin_tool_user!
  around_filter :strange_access
    
  layout :layout
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to "/"
  end
  
  # cancan expects current_user, so give it what it wants
  def current_user
    current_admin_tool_user
  end
  
  def is_super?
    current_user.roles.include?('super_admin')
  end

  # make params accessible by model so that I can get around type column name bug - this is not usually good form
  protected

  def strange_access
    klasses = [ActiveRecord::Base, ActiveRecord::Base.class]
    methods = ["session", "cookies", "params", "request"]

    methods.each do |m|
      oops = instance_variable_get(:"@_#{m}") 

      klasses.each do |klass|
        klass.send(:define_method, m, proc { oops })
      end
    end

    yield

    methods.each do |m|      
      klasses.each do |klass|
        klass.send :remove_method, m
      end
    end

  end  
  
  private

  def layout
    # only turn it off for login pages:
    is_a?(Devise::SessionsController) ? false : "application"
    # or turn layout off for every devise controller:
    # devise_controller? && "application"
  end
end

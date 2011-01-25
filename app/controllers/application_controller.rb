class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :authenticate_admin_tool_user!
  
  layout :layout
  
  rescue_from CanCan::AccessDenied do |exception|
    #flash[:alert] = exception.message
    redirect_to destroy_admin_tool_user_session_path #root_url
  end
  
  # cancan expects current_user, so give it what it wants
  def current_user
    current_admin_tool_user
  end
  
  def is_super?
    current_user.roles.include?('super_admin')
  end

  private

  def layout
    # only turn it off for login pages:
    is_a?(Devise::SessionsController) ? false : "application"
    # or turn layout off for every devise controller:
    # devise_controller? && "application"
  end
end

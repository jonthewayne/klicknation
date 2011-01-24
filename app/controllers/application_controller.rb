class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :authenticate_admin_tool_user!
  
  layout :layout

  private

  def layout
    # only turn it off for login pages:
    is_a?(Devise::SessionsController) ? false : "application"
    # or turn layout off for every devise controller:
    # devise_controller? && "application"
  end
  
  def current_user
    current_admin_tool_user
  end
end

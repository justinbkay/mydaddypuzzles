# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  #session :session_key => '_mydaddypuzzles_session_id'

  def security
    unless session[:admin] == 1
      flash[:notice] = "Please Authenticate"
      redirect_to :controller => :admin, :action => :login
    end
  end
end

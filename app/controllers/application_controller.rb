class ApplicationController < ActionController::Base
  protect_from_forgery

  def security
    unless session[:admin] == 1
      flash[:notice] = "Please Authenticate"
      redirect_to :controller => :admin, :action => :login
    end
  end

end

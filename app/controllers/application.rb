require_dependency 'login_system'
# The filters added to this controller will be run for all controllers in the application.
# Likewise will all the methods added be available for all controllers.
class ApplicationController < ActionController::Base
  include LoginSystem
  model :user
  
  before_filter :convert_charset, :set_charset
  before_filter :disable_link_prefetching, :only => [ :destroy ]
  private
  
  def set_charset
    @headers["Content-Type"] = "text/html; charset=ISO-8859-15"
  end
  
  def convert_charset
    @params.iconv!("iso-8859-15", "utf-8") if request.xhr?
  end
  
  def disable_link_prefetching
    if request.env["HTTP_X_MOZ"] == "prefetch" 
      logger.debug "prefetch detected: sending 403 Forbidden" 
      render_nothing "403 Forbidden" 
      return false
    end
  end
  
end

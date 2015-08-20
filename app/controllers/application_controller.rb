class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  rescue_from ActiveRestClient::HTTPServerException, with: :api_error
  
  protected
  
  def api_error(exception)
    flash[:error] = "PRS returned error #{exception.status}: #{exception.result.try(:message)}"
    redirect_to :back unless performed?
  end
end

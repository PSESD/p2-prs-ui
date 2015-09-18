class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  rescue_from ActiveRestClient::HTTPServerException, with: :api_error
  rescue_from ActiveRestClient::ConnectionFailedException, with: :connection_failure
  
  protected
  
  def api_error(exception)
    flash[:error] = "PRS returned error #{exception.status}: #{exception.result.try(:message)}"
    redirect_to :back unless performed?
  end
  
  def connection_failure(exception)
    render inline: "Error: Could not connect to PRS API."
  end
end
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from ActiveRestClient::HTTPServerException, with: :api_error
  rescue_from ActiveRestClient::ConnectionFailedException, with: :connection_failure
  rescue_from ActionController::RedirectBackError, with: :error_message

  protected

  def api_error(exception)
    flash[:error] = "PRS returned error #{exception.status}: #{exception.result.try(:message)}"
    redirect_to :back unless performed?
  rescue ActionController::RedirectBackError
    render inline: flash[:error]
  end

  def connection_failure(exception)
    render inline: "Error: Could not connect to PRS API."
  end

  def error_message(exception)
    @exception = exception
    render action: 'error_message'
  end
end

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

    def post(path, json_params)
      url = "https://srx-services-prs-dev.herokuapp.com#{path};zoneId=test;contextId=test"
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Post.new(uri.request_uri, header)
      request.body = json_params

      http.request(request).body
    end

    def put(path, json_params)
      url = "https://srx-services-prs-dev.herokuapp.com#{path};zoneId=test;contextId=test"
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Put.new(uri.request_uri, header)
      request.body = json_params

      http.request(request).body
    end

    def header
      { "Authorization" => "SIF_HMACSHA256 #{PrsModel.credentials[:auth_token]}",
        "Timestamp" => PrsModel.credentials[:timestamp],
        "GeneratorId" => "prs-ui",
        "Content-Type" => "json",
        "Accept" => "application/json",
        "ResponseFormat" => "object" }
    end
end

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from ActiveRestClient::HTTPServerException, with: :api_error
  rescue_from ActiveRestClient::ConnectionFailedException, with: :connection_failure
  rescue_from ActionController::RedirectBackError, with: :error_message

  helper_method :filters_headers

  ZoneId = Rails.application.secrets.prs_zone_id
  ContextId = Rails.application.secrets.prs_context_id

  def filters_headers(districtStudentId=nil)
    districtStudentId = @student.districtStudentId if districtStudentId.nil?

    { "authorizedEntityId" => @service.authorizedEntityId,
      "externalServiceId"  => @service.externalServiceId,
      "districtStudentId"  => districtStudentId,
      "objectType"         => (params[:object_type] || "xSre") }
  end

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

    def http_request(action, path, json_params)
      url = "#{PrsModel::BaseUrl}#{path};zoneId=#{ZoneId};contextId=#{ContextId}"
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = Rails.application.secrets.http_use_ssl
      if http.use_ssl == false
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      if action == "post"
        request = Net::HTTP::Post.new(uri.request_uri, PrsModel.headers)
      elsif action == "put"
        request = Net::HTTP::Put.new(uri.request_uri, PrsModel.headers)
      end

      request.body = json_params

      http.request(request).body
    end
end

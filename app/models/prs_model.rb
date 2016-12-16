class PrsModel < ActiveRestClient::Base
  extend ActiveModel::Naming

  base_url Rails.application.secrets.prs_url

  before_request :add_authentication_details
  request_body_type :json

  ZoneId = Rails.application.secrets.prs_zone_id
  ContextId = Rails.application.secrets.prs_context_id
  SessionToken = Rails.application.secrets.prs_session_token
  SharedSecret = Rails.application.secrets.prs_shared_secret

  attr_accessor :new_record

  def self.url_params
    ";zoneId=#{ZoneId};contextId=#{ContextId}"
  end

  def to_param
    id.to_s
  end

  def to_model
    self
  end

  def new_record?
     !@attributes.any? || new_record
  end
  def destroyed?()  false end
  def persisted?
    !new_record?
  end

  # Override the model name to remove the inherited namespace. This helps in appropriate form_for generation.
  def self.model_name
    ActiveModel::Name.new(self, nil, self.to_s.split("::").last)
  end

  def errors
    # obj = Object.new
    # def obj.[](key)         [] end
    # def obj.full_messages() [] end
    # obj
    @errors ||= ActiveModel::Errors.new(self)
  end

  # Override the #update method to manually set each attribute and call #save.
  # TODO: Figure out how to do this a better way with ActiveRestClient.
  def update(updated_attributes = {})
    for key, value in updated_attributes
      self[key] = value
    end
    save
  end

  protected

    def add_authentication_details(name, request)
      raise Exception.new("Missing authentication credentials") if SessionToken.nil? || SharedSecret.nil?

      set_response_headers(request)
    end

    def set_response_headers(response)
      response.headers["Authorization"] = "SIF_HMACSHA256 #{PrsModel.credentials[:auth_token]}"
      response.headers["Timestamp"] = PrsModel.credentials[:timestamp]
      response.headers["GeneratorId"] = "prs-ui"
      response.headers["Content-Type"] = "application/json"
      response.headers["Accept"] = "application/json"
      response.headers["ResponseFormat"] = "object"
    end

    def self.credentials
      timestamp = Time.now.utc.iso8601(3)

      { timestamp: timestamp,
        auth_token: PrsModel.generate_auth_token(timestamp) }
    end

    def self.generate_auth_token(timestamp)
      token_and_time = "#{SessionToken}:#{timestamp}"
      auth_hash = Base64.strict_encode64 OpenSSL::HMAC.digest('sha256', SharedSecret, token_and_time)
      auth_token = Base64.strict_encode64 "#{SessionToken}:#{auth_hash}"
    end
end

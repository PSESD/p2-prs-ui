class PrsModel < ActiveRestClient::Base
  extend ActiveModel::Naming

  BaseUrl = Rails.application.secrets.prs_url
  ContextId = Rails.application.secrets.prs_context_id
  SessionToken = Rails.application.secrets.prs_session_token
  SharedSecret = Rails.application.secrets.prs_shared_secret
  ZoneId = Rails.application.secrets.prs_zone_id

  attr_accessor :new_record

  def self.all(route)
    response = HTTParty.get(BaseUrl + route + url_params, headers: headers)
    attr_hashes = response.parsed_response
    create_objects(attr_hashes)
  end

  def self.create_objects(attr_hashes)
    attr_hashes.map.with_index do |attributes, index|
      self.new(attributes)
    end
  end

  def self.destroy(route)
    response = HTTParty.delete(BaseUrl + route + url_params, headers: headers)
    response.parsed_response
  end

  def self.find(route)
    current_headers = headers
    response = HTTParty.get(BaseUrl + route + url_params, headers: current_headers)
    object_hash = response.parsed_response
    create_objects(object_hash)
  end

  def self.headers
    { "Authorization" => "SIF_HMACSHA256 #{PrsModel.credentials[:auth_token]}",
      "Timestamp" => PrsModel.credentials[:timestamp],
      "GeneratorId" => "prs-ui",
      "Content-Type" => "application/json",
      "Accept" => "application/json",
      "ResponseFormat" => "object" }
  end

  # Override the model name to remove the inherited namespace. This helps in appropriate form_for generation.
  def self.model_name
    ActiveModel::Name.new(self, nil, self.to_s.split("::").last)
  end

  def self.url_params
    ";zoneId=#{ZoneId};contextId=#{ContextId}"
  end

  def initialize(attrs={})
    @attributes = {}
    @dirty_attributes = Set.new

    raise Exception.new("Cannot instantiate Base class") if self.class.name == "ActiveRestClient::Base"

    attrs.each do |attribute_name, attribute_value|
      attribute_name = attribute_name.to_sym
      if attribute_name.to_s.include?("Date")
        @attributes[attribute_name] = Date.parse(attribute_value)
      else
        @attributes[attribute_name] = attribute_value
      end
        @dirty_attributes << attribute_name
    end
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

  private

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

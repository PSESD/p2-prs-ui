class StudentSuccessLink::Organization
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic
  store_in collection: "organizations"

  field :name
  field :description
  field :website
  field :url
  field :authorizedEntityId, type: Integer
  field :externalServiceId, type: Integer

  validates_presence_of :name, :url, :authorizedEntityId, :externalServiceId

  # Returns the full URL of the organization record, which tracks the proper subdomain for login.
  # Suitable for printing directly.
  def full_url
    URI::HTTPS.build(url: url).to_s
  end

  def website_url
    website.blank? ? nil : URI::HTTP.build(host: website).to_s
  end

  def authorized_entity
    @authorized_entity ||= AuthorizedEntity.find(self[:authorizedEntityId])
    @authorized_entity.is_a?(AuthorizedEntity) ? @authorized_entity : nil
  rescue ActiveRestClient::HTTPNotFoundClientException
    @authorized_entity = nil
  end

  def authorized_entity_service
    @authorized_entity_service ||= AuthorizedEntity::Service.find(authorized_entity_id: self[:authorizedEntityId], id: self[:externalServiceId]) rescue nil
  rescue ActiveRestClient::HTTPNotFoundClientException
    @authorized_entity_service = nil
  end

  def admin_users
    StudentSuccessLink::User.where({ "permissions.role" => "admin", "permissions.organization" => id })
  end

  def add_admin_user(user)
    user.permissions.new(
      organization: id,
      activateStatus: "Active",
      activate: true,
      role: "admin"
    )
    user.save
  end

end

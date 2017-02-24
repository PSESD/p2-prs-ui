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
    url_host = url.split("//").last
    URI::HTTPS.build(host: url_host).to_s
  end

  def website_url
    website.blank? ? nil : URI::HTTP.build(host: website).to_s
  end

  def authorized_entity
    unless authorizedEntityId.nil?
      route = "/authorizedEntities/#{authorizedEntityId}"
      @authorized_entity = AuthorizedEntity.find(route)
    else
      @authorized_entity = nil
    end
  end

  def authorized_entity_service
    route = "/authorizedEntities/#{authorizedEntityId}/services/#{externalServiceId}"
    @authorized_entity_service = AuthorizedEntity::Service.find(route) rescue nil
  rescue ActiveRestClient::HTTPNotFoundClientException
    @authorized_entity_service = nil
  end

  def admin_users
    StudentSuccessLink::User.where({ "permissions.role" => "admin", "permissions.organization" => id })
  end

  def add_admin_user(user)
    user.permissions.new(organization: id,
                         activateStatus: "Active",
                         activate: true,
                         role: "admin")
    user.save
  end

# Pending further planning across SSL app.
  def create_admin_user(email, name)
    first_name, last_name = name.split

    user = StudentSuccessLink::User.new(email: email,
                                        first_name: first_name,
                                        last_name:last_name)

    user = set_permissions(user)
    user.save
  end

  def set_permissions(user)
    user.permissions.new(organization: id,
                         activateStatus: "Active",
                         activateDate: DateTime.now,
                         activate: true,
                         role: "admin")
  end

end

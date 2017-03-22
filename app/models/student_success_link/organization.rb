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
  # TODO: Check whether we need this. May be able to simply user url.
  def full_url
    url
    # url_host = url.split("//").last
    # URI::HTTPS.build(host: url_host).to_s
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
                                        last_name:last_name,
                                        salt: "tIiuVrTLw2x1gcoetqLMQo4py77js5pBNS0/jaN8DRsPoVk1/7ufqN9oUfzOH2/R3KBeGQRecMSyPGOnD6bAGh0Ple0MEuSB7TT0Cv1RKMaOvKBeEH7LxbzcYA4yIJ0zqem4VYuN2bH+ju3VvbZkJoWYF76zYEX9/cNcNygflS8=",
                                        hashedPassword: "78ac50fa6ab8335c8372c53ffa8df12a698961852cd7e0ab5ac0b3c0a5134848673d7eff6a6ad54d83d1a4e4959189340a868d507626c457d4f579c9a1a66caa6751cfef09b99227a0ac2bea9e0f72421773b10341711f1217f77365371fef2ad4d775b8a4a300c678e08da6186685898dcfb4b7bd4c01e1585dcd27794e7f68148cf8687ababbc60e1b4b7a96168e8ecc2c206cb278db93641438b625b1638bc08d19c41d138fa63c935ca1f817f62007147131cb9e8bee737ea4a3d2ead3da9a9fd8e5f08d962651bd30684151645dc8a3bb9656793cd69c3e351e2fb765720ad200c933fd176bee71708c879dc55191b76b3d4eb53b3272114e2110cd0a2ea8dfdd147d77d7614158305e07300a496f25052ae5e06669d3363c296fcf30a641bc9d94e17d3cdb22059fa718dc490673806b970ac9933212cff2205ab9ca5ec625eedee17ac3f21fa58365c8b1112f105bda15f419a9c03921dc759592d216ad6f95a504870c803b44e5d4c8bca275aa5f96af12009ef283c57051db2b7fb30ce865cc4596314fdbf8e8b162234a78f2d589df68500450d006a3b0d844d81e4080e683a0c5ed9d78b6179015695f9ac33c028d0294acadd632f94279eae4e65a770761948417f06af134cb946dd10425db22d93c32e755d64550c72bb89f699b56c29ce6d0aab503df225bd625efd500322852a14359860e16a77ec90f320f")

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

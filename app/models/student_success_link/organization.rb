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
                                        hashedPassword: "d1b768630c6afbf3b6ebfd2d5bfe1b89f3a49cbcceebac211f88b5f5bbc654899b98db5aefe312ab5af2ba993c9692d9862c09c20ea9dda3d4214f718e704d2b67981665633b15c79b809d8c36caa2a390bfb098ab1de4dfd35c82ad2a0203f845e4f5c168aae9d7bc28a68014eeece36384fd0e413e79fec4c1f81f0ad1717ba1c176ec7e8734e7e26658c260b79ec453c19622e68220ef9111c8b9aacd268c30008947215eb2a2e05f8748d12697e727b786ebaac243679b869ee0005e20759d57b7109c9389d911030f21d9229d4a53e90159d0a2a54ccd37ad16505c25fbe7d8807af4a159cf2808ffc95f46866367bdcaeafb6cf01d31e89a8ad54ff833bc8354a3511c8930ef502bdb01d6561dca8600d7c93c33942940fb407aec45a8ee5b2f7ca71fa3fa6f7ef2fa80e66a0cd3c78f4d604fe2931544fabfe64defb854ce181669ccfd9362f0fa98f9ea2bb1ea1b4e046ce338be02fc55017450a43b06ed539005c701a8282e1312602e8647c76647e9399459044b6ee062e1668b0db6b7fae3f55fe4665db35a515c799d042ec7c4101b211472c31f6627b05f672c4ce0b183e7eeafb61a2945c05233a9b834560cc6c04f024402130e5d6a826b22b00c6c2f0610627f6a6b21ef09ff23a3369886c21ae711244a5e690a5d928186ef3962cd69613b1463e8a87e05a5691ee5743a353b20df003ee9b15c1cf3fd98")

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

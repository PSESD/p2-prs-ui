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
                                        password: 'password',
                                        salt: "ii9V+ke4gLrKGZFi7J/wRvv7Yc7CoVYoXObU/vWEQkdcDEcErbYBnv57HQ4Ruu0h1NSAlgp2yFEhGUS21BFsMHcetjstHz+0x8JV1zRFZRcDvJLyshz4Qd4E8gIeN8mCPzlDyCZzSH1VSd5jE4A7rqwAQCKSX8gaqnndSXh6Ans=",
                                        hashed_password: "9e8e1c970c2e0fcd347eb2206baa1f83b96dd9aea5a116776c93078428e5667c319c5c9230d78184df7c3e3659999a58c9273e7a9a8530955cd061225d951cb426118016c409f3421600fbadbf37b4e70be0b5b46c0405550227f5ca4c2ad8cd97e6954212bef35c021a95dfbcefa683b0c8dda06742e3e7cf2c07868bccee96963e680c7a85bc44bc479c026060df5358ebfcc9d3307b90d24c2c09ce20cfbe62a1cba701da1e69699b7499caf9e8952a41f74199d57c37b0899c2e2e8f84a195b278c10f7633fe1f972a627b446f16e01f4c766b9ef15a971fc89bc72741716bef46f1b9f7c5798ca47b6727ed16437f6c9fe3e161721543255f0c6ad601e51c307dedf5ea2f763ed1ba24a23e93f3fb1ba5498c88bb4dbe08c7dd3156745bbc3ad5484dce252fb06549094da3e917500624867ed325002676100658b464c781ac01aa348d631372158fed76e903030e875f9361aebf036b94bf81a234eb99d0dfff2cb26287f9759df4fc89b66f144edda15ab6b7b251944f36dc2d1b33ec1ecd0d86406a838ee654d6ce9b38ebf940cadb6b17f93d7cfea742a7c7d7ba396289edbb8c297bdc9570a3d9b3291b182fd320c8ec5b798797dbd0ff78bd9fabf9225ff6d37c436bb38cb83512f75e089b8f2b1a2bbe1dbf460a4a073f868fd879410c9ce233b6861fb3d32ad839229e9b12659177387fe0a5908a8187496952")

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

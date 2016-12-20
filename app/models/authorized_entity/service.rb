class AuthorizedEntity::Service < PrsModel

  alias_attribute :name, :externalServiceName
  alias_attribute :description, :externalServiceDescription

  # Returns every AuthorizedEntity::Service from every AuthorizedEntity by looping
  # through them and returning a single result.
  def self.all_from_all
    all_authorized_entities = AuthorizedEntity.all
    all_services = all_authorized_entities.parallelise do |item|
      ae = AuthorizedEntity.find(item.id)
      ae.items.first.services
    end
    all_services.flatten
  end

  # Returns all of the District::Service records for this external service in a
  # hash where the district name is the key and an array of services are the values.

  # Are there any situations in which there are multiple services for a external service?
  def district_services(districts)
    @district_services ||= {}

    districts.each do |district|
      services = self.class.create_objects(district.services)
      @district_services[district.name] = services.find { |s| s.externalServiceId == id }
    end

    @district_services
  end

  # Returns the associated Organization record that's setup for this Service in
  # Student Success Link, matched by +authorizedEntityId+ and +externalServiceId+.
  # Returns +nil+ if no matching record is found.
  def ssl_organization
    @ssl_organization ||= StudentSuccessLink::Organization.find_by(authorizedEntityId: authorizedEntityId, externalServiceId: id)
  rescue Mongoid::Errors::DocumentNotFound => e
    @ssl_organization ||= nil
  end

end

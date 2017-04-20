class AuthorizedEntity < PrsModel

  def services_instantiated
    Service.create_objects(services)
  end

  def main_contact
    mainContact ? mainContact : {}
  end

  def possessive_name
    name[-1].downcase == "s" ? name + "'" : name + "'s"
  end

  def external_service
    services = AuthorizedEntity::Service.all("/authorizedEntities/#{id}/services")
    services.find { |service| service.authorizedEntityId == id }
  end

  def external_service_id
    external_service["id"]
  end

end

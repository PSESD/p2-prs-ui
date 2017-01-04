class AuthorizedEntity < PrsModel

  def mainContactObject
    Contact.new(mainContact) if mainContact
  end

  def services_instantiated
    Service.create_objects(services)
  end

  def services_count
    return services.size if services
    find(id).services.size
  end
end

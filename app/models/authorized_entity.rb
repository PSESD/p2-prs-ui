class AuthorizedEntity < PrsModel

  def services_instantiated
    Service.create_objects(services)
  end

  def services_count
    return services.size if services
    find(id).services.size
  end
  
end

class AuthorizedEntity < PrsModel

  def services_instantiated
    Service.create_objects(services)
  end

  def services_count
    return services.size if services
    find(id).services.size
  end

  def main_contact
    mainContact ? mainContact : {}
  end

  def possessive_name
    name[-1].downcase == "s" ? name + "'" : name + "'s"
  end
end

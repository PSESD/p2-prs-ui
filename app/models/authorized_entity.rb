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

  def webAddress_valid?
    valid_chars = ("A".."Z").to_a + ("a".."z").to_a + ["-"]
    valid_ascii = valid_chars.map(&:ord)

    url = mainContactObject.webAddress

    if url.count(".") != 2
      return false
    else
      ascii_url = url.split(".").first.chars.map(&:ord)
      ascii_url.all? { |ascii_char| valid_ascii.include?(ascii_char) }
    end
  end

end

class AuthorizedEntity < PrsModel
  # Returns the full record for all AuthorizedEntity objects by looping through all.
  # def self.all_full
  #   AuthorizedEntity.all do |item|
  #     AuthorizedEntity.find(item.id).first
  #   end
  # end

  def services_instantiated
    Service.create_objects(services)
  end

  def services_count
    return services.size if services
    find(id).services.size
  end
end

class AuthorizedEntity::Service < PrsModel
  get :all, "/authorizedEntities/:authorized_entity_id/services"
  get :find, "/authorizedEntities/:authorized_entity_id/services/:id"
  put :save, "/authorizedEntities/:authorized_entity_id/services/:id"
  post :create, "/authorizedEntities/:authorized_entity_id/services/"
  
  alias_attribute :name, :externalServiceName
  alias_attribute :description, :externalServiceDescription
  
  # Returns every AuthorizedEntity::Service from every AuthorizedEntity by looping 
  # through them and returning a single result.
  def self.all_from_all
    all_authorized_entities = AuthorizedEntity.all
    all_services = all_authorized_entities.parallelise do |item|
      ae = AuthorizedEntity.find(item.id)
      ae.services.items
    end
    all_services.flatten
  end
  
  # Returns all of the District::Service records for this external service in a
  # hash where the district name is the key and an array of services are the values.
  def district_services
    return @district_services if @district_services
    @district_services = {}
    District.all_full.each do |district|
      @district_services[district.name] ||= []
      @district_services[district.name] << district.services.select{ |s| s.externalServiceId == id }
    end
    @district_services
  end
  
end
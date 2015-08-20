class AuthorizedEntity < PrsModel

  get :all, "/authorizedEntities"
  get :find, "/authorizedEntities/:id", :has_many => { 
    :personnels => AuthorizedEntity::Personnel, 
    :services => AuthorizedEntity::Service 
  }
  put :save, "/authorizedEntities/:id"
  post :create, "/authorizedEntities"

  alias_attribute :name, :authorizedEntityName

  # Returns the full record for all AuthorizedEntity objects by looping through all.
  def self.all_full
    AuthorizedEntity.all.parallelise do |item|
      AuthorizedEntity.find item.id
    end
  end

  def services_count
    return services.size if services
    find(id).services.size
  end

end
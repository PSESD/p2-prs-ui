class AuthorizedEntity < PrsModel

  get :all, "/authorizedEntities" + url_params
  get :find, "/authorizedEntities/:id" + url_params, :has_many => {
    :personnels => AuthorizedEntity::Personnel,
    :services => AuthorizedEntity::Service
  }, :has_one => {
    :mainContact => Contact
  }
  put :save, "/authorizedEntities/:id" + url_params
  post :create, "/authorizedEntities" + url_params

  # Returns the full record for all AuthorizedEntity objects by looping through all.
  def self.all_full
    AuthorizedEntity.all.parallelise do |item|
      AuthorizedEntity.find(item.id).items.first
    end
  end

  def services_count
    return services.size if services
    find(id).services.size
  end

end

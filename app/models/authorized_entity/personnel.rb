class AuthorizedEntity::Personnel < PrsModel
  get :all, "/authorizedEntities/:authorized_entity_id/personnel" + url_params
  get :find, "/authorizedEntities/:authorized_entity_id/personnel/:id" + url_params
  put :save, "/authorizedEntities/:authorized_entity_id/personnel/:id" + url_params
  post :create, "/authorizedEntities/:authorized_entity_id/personnel/" + url_params

  # alias_attribute :name, :externalServiceExternalServiceName

end

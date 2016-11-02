class AuthorizedEntity::Personnel < PrsModel
  get :all, "/authorized_entities/:authorized_entity_id/personnel" + url_params
  get :find, "/authorized_entities/:authorized_entity_id/personnel/:id" + url_params
  put :save, "/authorized_entities/:authorized_entity_id/personnel/:id" + url_params
  post :create, "/authorized_entities/:authorized_entity_id/personnel/" + url_params

  # alias_attribute :name, :externalServiceExternalServiceName

end

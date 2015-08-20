class AuthorizedEntity::Personnel < PrsModel
  get :all, "/authorized_entities/:authorized_entity_id/personnel"
  get :find, "/authorized_entities/:authorized_entity_id/personnel/:id"
  put :save, "/authorized_entities/:authorized_entity_id/personnel/:id"
  post :create, "/authorized_entities/:authorized_entity_id/personnel/"
  
  # alias_attribute :name, :externalServiceExternalServiceName
  
end

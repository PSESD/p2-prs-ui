json.array!(@authorized_entities) do |authorized_entity|
  json.extract! authorized_entity, :id, :authorizedEntityName
  json.url authorized_entity_url(authorized_entity, format: :json)
end

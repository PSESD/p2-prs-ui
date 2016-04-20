json.array!(@organizations) do |organization|
  json.extract! organization, :id, :name
  json.url url_for(organization, format: :json)
end

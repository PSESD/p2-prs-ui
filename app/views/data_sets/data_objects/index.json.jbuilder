json.array!(@data_sets_data_objects) do |data_sets_data_object|
  json.extract! data_sets_data_object, :id
  json.url data_sets_data_object_url(data_sets_data_object, format: :json)
end

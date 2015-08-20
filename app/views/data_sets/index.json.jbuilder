json.array!(@data_sets) do |data_set|
  json.extract! data_set, :id, :dataSetName, :dataSetDescription
  json.url data_set_url(data_set, format: :json)
end

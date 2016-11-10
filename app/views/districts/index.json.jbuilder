json.array!(@districts) do |district|
  json.extract! district, :id, :name, :ncesleaCode, :zoneID
  json.url district_url(district, format: :json)
end

json.array!(@districts) do |district|
  json.extract! district, :id, :districtName, :ncesleaCode, :zoneID
  json.url district_url(district, format: :json)
end

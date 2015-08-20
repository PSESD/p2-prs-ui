json.array!(@district_services) do |district_service|
  json.extract! district_service, :id
  json.url district_service_url(district_service, format: :json)
end

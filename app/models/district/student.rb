class District::Student < PrsModel

  verbose true if Rails.env.development?

  # get :filters, "/filters" + url_params

  before_request do |name, request|
    if name == :filters
      # Convert get params to headers because that's the way PRS likes them.
      for param in %w[districtId authorizedEntityId externalServiceId districtStudentId objectType personnelId]
        request.headers[param] = request.get_params.delete(param.to_sym).to_s if request.get_params[param.to_sym]
      end
    end
  end

  ConsentTypes = [
    "Parent Consent",
    "Institutional Designation",
    "Research Exemption"
  ]

  # def consentEndDate
  #   Date.parse(self.consent.try(:consentEndDate)) rescue nil
  # end
  #
  # def expired?
  #   consentEndDate.today? || consentEndDate.past? if consentEndDate.is_a?(Date)
  # end

  def self.filters(route, header_params)
    filter_headers = set_headers(header_params)

    response = HTTParty.get(BaseUrl + route + url_params, headers: filter_headers)
    response.parsed_response
  end

  def self.set_headers(header_params)
    all_headers = headers.merge(header_params)
    all_headers.delete("Accept")
    all_headers
  end
end

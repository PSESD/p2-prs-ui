class District::Student < PrsModel

  verbose true if Rails.env.development?

  ConsentTypes = [
    "Parent Consent",
    "Institutional Designation",
    "Research Exemption"
  ]

  HTTParty::Basement.default_options.update(verify: false)

  # def consentEndDate
  #   Date.parse(self.consent.try(:consentEndDate)) rescue nil
  # end
  #
  # def expired?
  #   consentEndDate.today? || consentEndDate.past? if consentEndDate.is_a?(Date)
  # end

  def self.filters(route, filters_headers)
    filter_headers = set_headers(filters_headers)

    response = HTTParty.get(BaseUrl + route + url_params, headers: filter_headers)
    result = response.parsed_response

    result_json = result.to_json
    result_xml = JSON.parse(result_json).to_xml
  end

  def self.set_headers(filters_headers)
    all_headers = headers.merge(filters_headers)
    all_headers.delete("Accept")
    all_headers
  end

  def consentType
    consent["consentType"] if consent
  end

  def consentStartDate
    Date.parse(consent["startDate"]) if consent
  end

  def consentEndDate
    Date.parse(consent["endDate"]) if consent
  end

  def formConsent
    consent.nil? ? {} : consent
  end
end

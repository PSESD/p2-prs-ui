class District::Student < PrsModel

  verbose true if Rails.env.development?

  get :find, "/districts/:district_id/services/:service_id/students/:id" + url_params #, :has_one => { :consent => District::StudentConsent }
  put :save, "/districts/:district_id/services/:service_id/students/:id" + url_params
  post :create, "/districts/:district_id/services/:service_id/students/" + url_params
  delete :destroy, "/districts/:district_id/services/:service_id/students/:id" + url_params
  get :filters, "/filters" + url_params

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

end

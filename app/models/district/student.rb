class District::Student < PrsModel
  
  verbose true if Rails.env.development?
  
  get :all, "/districts/:district_id/services/:service_id/students"
  get :find, "/districts/:district_id/services/:service_id/students/:id" #, :has_one => { :consent => District::StudentConsent }
  put :save, "/districts/:district_id/services/:service_id/students/:id"
  post :create, "/districts/:district_id/services/:service_id/students/"
  delete :destroy, "/districts/:district_id/services/:service_id/students/:id"

  ConsentTypes = [
    "Parent Consent",
    "Institutional Designation",
    "Research Exemption"
  ]

end

class DataSet::DataObject < PrsModel
  
  verbose true if Rails.env.development?
  
  get :all,     "/dataSets/:data_set_id/sifdataobjects"
  get :find,    "/dataSets/:data_set_id/sifdataobjects/:id"
  put :save,    "/dataSets/:data_set_id/sifdataobjects/:id"
  post :create, "/dataSets/:data_set_id/sifdataobjects/"
  delete :destroy, "/dataSets/:data_set_id/sifdataobjects/:id"
  
  def filterTypeLabel
    filterType.is_a?(String) ? filterType : %w[Include Exclude][filterType]
  end
  
end

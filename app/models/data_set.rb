class DataSet < PrsModel

  verbose true if Rails.env.development?

  get :all, "/dataSets" + url_params
  get :find, "/dataSets/:id" + url_params, :has_many => { dataObjects: DataSet::DataObject }
  put :save, "/dataSets/:id" + url_params
  post :create, "/dataSets/" + url_params
  delete :destroy, "/dataSets/:id" + url_params

end

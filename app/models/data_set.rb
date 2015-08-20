class DataSet < PrsModel

  verbose true if Rails.env.development?
  
  get :all, "/dataSets"
  get :find, "/dataSets/:id", :has_many => { sifDataObjects: DataSet::DataObject }
  put :save, "/dataSets/:id"
  post :create, "/dataSets/"
  delete :destroy, "/dataSets/:id"

  alias_attribute :name, :dataSetName
  alias_attribute :description, :dataSetDescription

end
class District::Service < PrsModel
  
  verbose true if Rails.env.development?
  
  get :all, "/districts/:district_id/services"
  get :find, "/districts/:district_id/services/:id", :has_many => { :students => District::Student, :dataSets => DataSet }
  put :save, "/districts/:district_id/services/:id"
  post :create, "/districts/:district_id/services/"
  delete :destroy, "/districts/:district_id/services/:id"
  
  alias_attribute :name, :externalServiceExternalServiceName

  before_request :replace_body
  
  def students
    District::Student.all(district_id: districtId, service_id: id)
  end
  
  def students_full
    students.collect do |student|
      District::Student.find(district_id: districtId, service_id: id, id: student.id)
    end
  end
  
  def initiationDate
    Date.parse self[:initiationDate] rescue nil
  end
  
  def expirationDate
    Date.parse self[:expirationDate] rescue nil
  end
  
  def authorized_for_data_set?(data_set)
    return false unless dataSets
    data_set_ids = dataSets.collect(&:id)
    data_set_ids.include? (data_set.is_a?(DataSet) ? data_set.id : data_set)
  end
    
  private
  
  def replace_body(name, request)
    if name.in? [:create, :save]
      post_params = request.post_params
      puts post_params
      xml = post_params.to_xml(root: "DistrictServiceDetail", camelize: true)
      xml.gsub!(/^  <DataSetSummary/, "  <DataSets") # hack to change the top-level key the way the PRS API wants it
      xml.gsub!(/^  <\/DataSetSummary/, "  </DataSets")
      request.body = xml
      request.headers["Content-Type"] = "application/xml"
    end
  end
  
end

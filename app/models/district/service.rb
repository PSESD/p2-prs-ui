class District::Service < PrsModel

  verbose true if Rails.env.development?

  alias_attribute :name, :externalServiceName

  def data_sets_instantiated
    dataSets.map do |data_set|
      DataSet.new(data_set)
    end
  end

  def students
    route = "/districts/#{districtId}/services/#{id}/students"
    District::Student.all(route)
  end

  def students_full
    students.collect do |student|
      District::Student.find(district_id: districtId, service_id: id, id: student.id)
    end
  end

  def expired?
    expirationDate.today? || expirationDate.past? if expirationDate.is_a?(Date)
  end

  def authorized_for_data_set?(data_set)
    return false unless dataSets
    data_set_ids = dataSets.collect{ |x| x[:id] ? x[:id] : x["id"]}
    data_set_ids.include? (data_set.is_a?(DataSet) ? data_set.id : data_set)
  end

  def authorized_entity
    route = "/authorizedEntities/" + authorizedEntityId
    AuthorizedEntity.find(route).first
  end

  def mainContact
    contact = authorized_entity.mainContact
    contact ? contact : {}
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

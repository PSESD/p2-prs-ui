class DataSet < PrsModel

  verbose true if Rails.env.development?

  def data_objects_instantiated
    dataObjects.map { |data_object| DataSet::DataObject.new(data_object) }
  end

end

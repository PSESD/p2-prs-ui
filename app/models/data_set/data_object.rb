class DataSet::DataObject < DataSet

  verbose true if Rails.env.development?

  alias_attribute :dataSetId, :data_set_id

  def filterTypeLabel
    filterType.is_a?(String) ? filterType : %w[Include Exclude][filterType]
  end

end

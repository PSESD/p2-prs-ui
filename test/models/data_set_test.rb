require 'test_helper'

class DataSetTest < ActiveSupport::TestCase
  test "should not save data set without a name" do
    data_set = DataSet.new
    assert_raises ActiveRestClient::HTTPBadRequestClientException do
      data_set.save
    end
  end
end

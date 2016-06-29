require 'test_helper'

class DataSetTest < ActiveSupport::TestCase
  test "should not save data set without a name" do
    data_set = DataSet.new
    assert_raises ActiveRestClient::HTTPServerException do
      data_set.create
    end
  end

  test "should save a new data set with valid name and description and then delete it" do
    data_set = DataSet.new
    data_set.name = "Test Dataset"
    data_set.description = "Test description"
    assert_nothing_raised ActiveRestClient::HTTPServerException do
      data_set.create
    end
    assert_nothing_raised ActiveRestClient::HTTPServerException do
      data_set.destroy
    end
  end
  
end

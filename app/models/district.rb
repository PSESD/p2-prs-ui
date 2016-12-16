class District < PrsModel
  verbose true if Rails.env.development?

  # get :all, "/districts" + url_params
  get :find, "/districts/:id" + url_params, :has_many => { :services => District::Service }, :has_one => { :mainContact => Contact }
  put :save, "/districts/:id" + url_params
  post :create, "/districts" + url_params
  delete :destroy, "/districts/:id" + url_params

  def self.all
    response = HTTParty.get(BaseUrl + "/districts" + url_params, headers: headers)
    districts_hash = response.parsed_response
    create_objects(districts_hash)
  end

  def self.create_objects(districts_hash)
    districts_hash.map do |district_hash|
      District.new(district_hash)
    end
  end

  def self.all_full
    # parallelise
    District.all.parallelise do |item|
      District.find item.id
    end
  end

  def services_full
    # .parallelise
    District::Service.all(district_id: id).parallelise do |item|
      District::Service.find(district_id: id, id: item.id)
    end
    # District::Service.all(district_id: id).items
  end
end

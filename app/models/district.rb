class District < PrsModel
  verbose true if Rails.env.development?

  #  get :find, "/districts/:id" + url_params, :has_many => { :services => District::Service }, :has_one => { :mainContact => Contact }
  #  put :save, "/districts/:id" + url_params
  #  post :create, "/districts" + url_params, :has_one => { :mainContact => Contact }


    # :has_many => { :services => District::Service }, :has_one => { :mainContact => Contact }
    # has_one :mainContact => Contact

  def self.all_full
    District.all.parallelise do |item|
      District.find item.id
    end
  end

  def mainContact(attrs={})
    @mainContact ||= Contact.new(attrs)
  end

  def services_full
    District::Service.all(district_id: id).parallelise do |item|
      District::Service.find(district_id: id, id: item.id)
    end
  end
end

class District < PrsModel
  verbose true if Rails.env.development?

  def self.all_full
    District.all.parallelise do |item|
      District.find item.id
    end
  end

  def services_full
    District::Service.all(district_id: id).parallelise do |item|
      District::Service.find(district_id: id, id: item.id)
    end
  end
end

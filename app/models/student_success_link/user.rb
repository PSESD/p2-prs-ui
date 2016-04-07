class StudentSuccessLink::User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic
  store_in collection: "users"
  
  embeds_many :permissions
  
  field :first_name
  field :last_name
  field :email
  
  def full_name
    "#{first_name} #{last_name}"
  end
  
end
class StudentSuccessLink::User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic
  store_in collection: "users"
  
  embeds_many :permissions, class_name: "StudentSuccessLink::User::Permission"
  
  field :first_name
  field :last_name
  field :email
  
  validates_presence_of :first_name, :last_name, :email
  
  def full_name
    "#{first_name} #{last_name}"
  end
end

class StudentSuccessLink::User::Permission
  include Mongoid::Document
  embedded_in :user, class_name: "StudentSuccessLink::User"
  
  field :organization, type: BSON::ObjectId
  field :activateStatus
  field :activateDate, type: DateTime
  field :activate, type: Boolean
  field :role
  field :permissions, type: Array
  field :students, type: Array
  
  validates_presence_of :organization, :role
  validates_inclusion_of :activateStatus, in: %w[Pending Active]
  validates_inclusion_of :activate, in: [true, false]
  validates_inclusion_of :role, in: %w[admin case-worker-unrestricted case-worker-restricted]
  validates_uniqueness_of :organization
  
end

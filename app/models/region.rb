class Region
  include Mongoid::Document
  include Mongoid::Timestamps

  field :_n, as: :name, type: String
  field :_c, as: :code, type: String

  has_many :products, class_name: "Product", inverse_of: :region

  validates :name, presence: true, uniqueness: true
  validates :code, presence: true, uniqueness: true
end